import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_export_data.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_metrics.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/repos/time_summary_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/domain/repos/time_summary_repo.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:intl/intl.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';

enum TimeSummaryPreset { last7Days, last2Weeks, last30Days, last1Year, custom }

class TimeSummaryController extends GetxController {
  static TimeSummaryController get instance => Get.find();

   TimeSummaryRepo repo = TimeSummaryRepoImpl();

  // ---------------------------
  // State
  // ---------------------------
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final Rx<TimeSummaryKpis?> kpis = Rx<TimeSummaryKpis?>(null);
  final RxList<FlSpot> studentSpots = <FlSpot>[].obs;
  final RxList<FlSpot> tutorSpots = <FlSpot>[].obs;

  final Rx<TimeSummaryPreset> preset = TimeSummaryPreset.last30Days.obs;
  final Rxn<DateTime> customStart = Rxn<DateTime>();
  final Rxn<DateTime> customEnd = Rxn<DateTime>();
  final RxBool includeOngoing = false.obs;
  final RxList<TutorHoursRollup> tutorRollUps = <TutorHoursRollup>[].obs;

  // ---------------------------
  // Public API (for the page)
  // ---------------------------

  /// Call this in initState (use postFrameCallback if needed)
  Future<void> fetchSummary() async {
    error.value = '';
    isLoading.value = true;

    try {
      final range = _resolveRange();
      final res = await repo.getTimeSummary(
        range: range,
        includeOngoing: includeOngoing.value,
      );

      // KPIs
      kpis.value = res.kpis;

      // Chart
      studentSpots.assignAll(res.studentSpots);
      tutorSpots.assignAll(res.tutorSpots);

      // BUILD ROLLUPS HERE
      tutorRollUps.assignAll(res.topTutors);

      // Top tutors (if included in response)
      if (res.topTutors.isNotEmpty) {
        tutorRollUps.assignAll(res.topTutors);
      } else {
        // If you don't return topTutors, keep existing list (or clear)
        tutorRollUps.clear();
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }

    debugPrint(
      'studentSpots: ${studentSpots.length}, tutorSpots: ${tutorSpots.length}',
    );
  }

  DateRangeX get currentRange => _resolveRange();

  /// Switch preset: 7 days / 30 days / 1 year (auto refresh)
  Future<void> setPreset(TimeSummaryPreset newPreset) async {
    preset.value = newPreset;
    if (newPreset != TimeSummaryPreset.custom) {
      customStart.value = null;
      customEnd.value = null;
    }
    await fetchSummary();
  }

  /// Set custom range and refresh
  Future<void> setCustomRange({
    required DateTime start,
    required DateTime end,
  }) async {
    preset.value = TimeSummaryPreset.custom;
    customStart.value = start;
    customEnd.value = end;
    await fetchSummary();
  }

  /// Toggle counting ongoing sessions and refresh
  Future<void> toggleIncludeOngoing(bool v) async {
    includeOngoing.value = v;
    await fetchSummary();
  }

  // ---------------------------
  // Convenience getters (for UI)
  // ---------------------------
  int get studentSessions => kpis.value?.studentSessions ?? 0;

  int get tutorSignIns => kpis.value?.tutorSignIns ?? 0;

  int get totalSignIns => kpis.value?.totalSignIns ?? 0;

  double get totalStudentHours => kpis.value?.totalStudentHoursFloat ?? 0.0;

  double get totalTutorHours => kpis.value?.totalTutorHoursFloat ?? 0.0;

  // ---------------------------
  // Internals
  // ---------------------------
  DateRangeX _resolveRange() {
    switch (preset.value) {
      case TimeSummaryPreset.last7Days:
        return DateRangeX.last7Days();
      case TimeSummaryPreset.last2Weeks:
        return DateRangeX.last2Weeks();
      case TimeSummaryPreset.last30Days:
        return DateRangeX.last30Days();
      case TimeSummaryPreset.last1Year:
        return DateRangeX.last1Year();
      case TimeSummaryPreset.custom:
        final s = customStart.value;
        final e = customEnd.value;
        if (s == null || e == null) return DateRangeX.last30Days();
        return DateRangeX(
          start: DateTime(s.year, s.month, s.day),
          endInclusive: DateTime(e.year, e.month, e.day, 23, 59, 59),
        );
    }
  }

  Future<void> exportTutorLogsToExcel() async {
    try {
      error.value = '';

      final range = currentRange;

      final snapshot = await TimeSummaryRepoImpl()
          .tutorHistoryCollection
          .where(
        'created_at',
        isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
      )
          .where(
        'created_at',
        isLessThanOrEqualTo: Timestamp.fromDate(range.endInclusive),
      )
          .orderBy('created_at', descending: true)
          .get();

      final rawLogs = snapshot.docs
          .map((doc) => TutorLoginHistory.fromMap(doc.data(), doc.id))
          .toList();

      final logs = dedupeTutorLogs(rawLogs);

      final totalHoursByTutor = <String, TutorExportTotal>{};

      for (final log in logs) {
        final tutorId = log.tutorId ?? log.tutorRef?.id;
        if (tutorId == null || tutorId.isEmpty) continue;

        final cappedDuration = _calculateBusinessCappedDuration(
          log.timeIn,
          log.timeOut,
        );

        if (totalHoursByTutor.containsKey(tutorId)) {
          totalHoursByTutor[tutorId]!.total += cappedDuration ?? Duration.zero;
        } else {
          totalHoursByTutor[tutorId] = TutorExportTotal(
            tutorId: tutorId,
            tutorName: log.tutorName ?? '',
            tutorEmail: log.tutorEmail ?? '',
            total: cappedDuration ?? Duration.zero,
          );
        }
      }

      final workbook = xlsio.Workbook();
      final sheet = workbook.worksheets[0];
      sheet.name = 'Tutor Logs';

      final headers = [
        'Date',
        'Tutor ID',
        'Tutor Name',
        'Email',
        'Time In',
        'Time Out',
        'Actual Duration',
        'Billable Duration (Max 5 hrs)',
        'Total Hours (Capped)',
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle.bold = true;
        cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      }

      int row = 2;
      DateTime? lastPrintedDate;

      for (final log in logs) {
        final sessionDate = log.timeIn ?? log.createdAt;
        final duration = _calculateSessionDuration(log.timeIn, log.timeOut);
        final cappedDuration = _calculateBusinessCappedDuration(
          log.timeIn,
          log.timeOut,
        );

        final tutorId = log.tutorId ?? log.tutorRef?.id ?? '';

        final isNewDateGroup =
            sessionDate != null &&
                (lastPrintedDate == null ||
                    !_isSameDate(lastPrintedDate, sessionDate));

        if (isNewDateGroup) {
          final dateText = DateFormat('MM/dd/yyyy').format(sessionDate);

          // Set the date text
          sheet.getRangeByIndex(row, 1).setText(dateText);

          final dateRow = sheet.getRangeByIndex(row, 1, row, 9);

          // 🔥 Dark background
          dateRow.cellStyle.backColor = '#D3D3D3';

          // 🔥 White text
          dateRow.cellStyle.fontColor = '#000000';

          // Optional: bold
          dateRow.cellStyle.bold = true;

          // Keep borders
          dateRow.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

          lastPrintedDate = sessionDate;
          row++;
        }

        sheet.getRangeByIndex(row, 1).setText('');
        sheet.getRangeByIndex(row, 2).setText(tutorId);
        sheet.getRangeByIndex(row, 3).setText(log.tutorName ?? '');
        sheet.getRangeByIndex(row, 4).setText(log.tutorEmail ?? '');
        sheet.getRangeByIndex(row, 5).setText(_formatDateTimeCsv(log.timeIn));
        sheet.getRangeByIndex(row, 6).setText(_formatDateTimeCsv(log.timeOut));
        sheet.getRangeByIndex(row, 7).setText(_formatDurationCsv(duration));
        sheet.getRangeByIndex(row, 8).setText(_formatDurationCsv(cappedDuration));
        sheet.getRangeByIndex(row, 9).setText('');

        applyRowBorders(sheet, row, 1, 9);
        row++;
      }

      row++;

      final sortedTotals = totalHoursByTutor.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));

      for (final t in sortedTotals) {
        sheet.getRangeByIndex(row, 1).setText('');
        sheet.getRangeByIndex(row, 2).setText('');
        sheet.getRangeByIndex(row, 3).setText(t.tutorName);
        sheet.getRangeByIndex(row, 4).setText(t.tutorEmail);
        sheet.getRangeByIndex(row, 5).setText('');
        sheet.getRangeByIndex(row, 6).setText('');
        sheet.getRangeByIndex(row, 7).setText('');
        sheet.getRangeByIndex(row, 8).setText('');
        sheet.getRangeByIndex(
          row,
          9,
        ).setNumber(double.parse((t.total.inMinutes / 60.0).toStringAsFixed(0)));

        final totalRow = sheet.getRangeByIndex(row, 3, row, 9);
        totalRow.cellStyle.backColor = '#FFF200';
        totalRow.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

        row++;
      }

      sheet.getRangeByIndex(1, 1, row - 1, 9).autoFitColumns();

      final bytes = workbook.saveAsStream();
      workbook.dispose();

      final blob = html.Blob(
        [bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      final url = html.Url.createObjectUrlFromBlob(blob);

      final fileName =
          'tutor_logs_${DateFormat('yyyyMMdd').format(range.start)}_${DateFormat('yyyyMMdd').format(range.endInclusive)}.xlsx';

      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      error.value = 'Failed to export tutor logs Excel file: $e';
    }
  }

  Future<void> exportSpecificTutorLogsToExcel(String tutorId) async {
    try {
      error.value = '';

      final range = currentRange;

      final snapshot = await TimeSummaryRepoImpl()
          .tutorHistoryCollection
          .where('tutor_id', isEqualTo: tutorId)
          .where(
        'created_at',
        isGreaterThanOrEqualTo: Timestamp.fromDate(range.start),
      )
          .where(
        'created_at',
        isLessThanOrEqualTo: Timestamp.fromDate(range.endInclusive),
      )
          .orderBy('created_at', descending: true)
          .get();

      final rawLogs = snapshot.docs
          .map((doc) => TutorLoginHistory.fromMap(doc.data(), doc.id))
          .where((log) => (log.tutorId ?? log.tutorRef?.id) == tutorId)
          .toList();

      final logs = dedupeTutorLogs(rawLogs);

      if (logs.isEmpty) {
        error.value = 'No logs found for this tutor in the selected period.';
        return;
      }

      final workbook = xlsio.Workbook();
      final sheet = workbook.worksheets[0];
      sheet.name = 'Tutor Logs';

      final headers = [
        'Date',
        'Tutor ID',
        'Tutor Name',
        'Email',
        'Time In',
        'Time Out',
        'Actual Duration',
        'Billable Duration (Max 5 hrs)',
        'Total Hours (Capped)',
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.getRangeByIndex(1, i + 1);
        cell.setText(headers[i]);
        cell.cellStyle.bold = true;
        cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      }

      int row = 2;
      DateTime? lastPrintedDate;
      Duration totalCapped = Duration.zero;

      final sortedLogs = [...logs]..sort((a, b) {
        final aTime = a.timeIn ?? a.createdAt ?? DateTime(1970);
        final bTime = b.timeIn ?? b.createdAt ?? DateTime(1970);
        return bTime.compareTo(aTime);
      });

      for (final log in sortedLogs) {
        final sessionDate = log.timeIn ?? log.createdAt;
        final duration = _calculateSessionDuration(log.timeIn, log.timeOut);
        final cappedDuration = _calculateBusinessCappedDuration(
          log.timeIn,
          log.timeOut,
        );

        if (cappedDuration != null) {
          totalCapped += cappedDuration;
        }

        final currentTutorId = log.tutorId ?? log.tutorRef?.id ?? '';

        final isNewDateGroup =
            sessionDate != null &&
                (lastPrintedDate == null ||
                    !_isSameDate(lastPrintedDate!, sessionDate));

        if (isNewDateGroup) {
          final dateText = DateFormat('MM/dd/yyyy').format(sessionDate);

          sheet.getRangeByIndex(row, 1).setText(dateText);

          final dateRow = sheet.getRangeByIndex(row, 1, row, 9);
          dateRow.cellStyle.backColor = '#D3D3D3';
          dateRow.cellStyle.fontColor = '#000000';
          dateRow.cellStyle.bold = true;
          dateRow.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

          lastPrintedDate = sessionDate;
          row++;
        }

        sheet.getRangeByIndex(row, 1).setText('');
        sheet.getRangeByIndex(row, 2).setText(currentTutorId);
        sheet.getRangeByIndex(row, 3).setText(log.tutorName ?? '');
        sheet.getRangeByIndex(row, 4).setText(log.tutorEmail ?? '');
        sheet.getRangeByIndex(row, 5).setText(_formatDateTimeCsv(log.timeIn));
        sheet.getRangeByIndex(row, 6).setText(_formatDateTimeCsv(log.timeOut));
        sheet.getRangeByIndex(row, 7).setText(_formatDurationCsv(duration));
        sheet.getRangeByIndex(row, 8).setText(_formatDurationCsv(cappedDuration));
        sheet.getRangeByIndex(row, 9).setText('');

        applyRowBorders(sheet, row, 1, 9);
        row++;
      }

      row++;

      final firstLog = sortedLogs.first;
      final tutorName = firstLog.tutorName ?? '';
      final tutorEmail = firstLog.tutorEmail ?? '';

      sheet.getRangeByIndex(row, 1).setText('');
      sheet.getRangeByIndex(row, 2).setText('');
      sheet.getRangeByIndex(row, 3).setText(tutorName);
      sheet.getRangeByIndex(row, 4).setText(tutorEmail);
      sheet.getRangeByIndex(row, 5).setText('');
      sheet.getRangeByIndex(row, 6).setText('');
      sheet.getRangeByIndex(row, 7).setText('');
      sheet.getRangeByIndex(row, 8).setText('');
      sheet
          .getRangeByIndex(row, 9)
          .setNumber(double.parse((totalCapped.inMinutes / 60.0).toStringAsFixed(0)));

      final totalRow = sheet.getRangeByIndex(row, 3, row, 9);
      totalRow.cellStyle.backColor = '#FFF200';
      totalRow.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

      sheet.getRangeByIndex(1, 1, row, 9).autoFitColumns();

      final bytes = workbook.saveAsStream();
      workbook.dispose();

      final blob = html.Blob(
        [bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      final url = html.Url.createObjectUrlFromBlob(blob);

      final safeTutorId = tutorId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
      final fileName =
          'tutor_logs_${safeTutorId}_${DateFormat('yyyyMMdd').format(range.start)}_${DateFormat('yyyyMMdd').format(range.endInclusive)}.xlsx';

      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      error.value = 'Failed to export tutor logs Excel file: $e';
    }
  }

  void applyRowBorders(
      xlsio.Worksheet sheet,
      int row,
      int startCol,
      int endCol,
      ) {
    final range = sheet.getRangeByIndex(row, startCol, row, endCol);
    range.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
  }

  //Remove duplicate rows
  List<TutorLoginHistory> dedupeTutorLogs(List<TutorLoginHistory> logs) {
    logs.sort((a, b) {
      final aTime = a.createdAt ?? a.timeIn ?? DateTime(1970);
      final bTime = b.createdAt ?? b.timeIn ?? DateTime(1970);
      return bTime.compareTo(aTime);
    });

    final unique = <TutorLoginHistory>[];
    final lastSeenByTutor = <String, DateTime>{};

    for (final log in logs) {
      final tutorId = log.tutorId ?? log.tutorRef?.id;
      final stamp = log.createdAt ?? log.timeIn;

      if (tutorId == null || stamp == null) {
        unique.add(log);
        continue;
      }

      final lastSeen = lastSeenByTutor[tutorId];
      if (lastSeen != null && lastSeen.difference(stamp).inSeconds.abs() <= 60) {
        continue;
      }

      lastSeenByTutor[tutorId] = stamp;
      unique.add(log);
    }

    return unique;
  }

  Duration? _calculateSessionDuration(DateTime? timeIn, DateTime? timeOut) {
    if (timeIn == null || timeOut == null) return null;
    if (timeOut.isBefore(timeIn)) return null;
    return timeOut.difference(timeIn);
  }
  //
  // Duration? _calculateCappedSessionDuration(DateTime? timeIn, DateTime? timeOut) {
  //   if (timeIn == null || timeOut == null) return null;
  //   if (timeOut.isBefore(timeIn)) return null;
  //
  //   final rawDuration = timeOut.difference(timeIn);
  //   const maxDuration = Duration(hours: 5);
  //
  //   return rawDuration > maxDuration ? maxDuration : rawDuration;
  // }

  DateTime? _clampTimeOutTo5Pm(DateTime? timeIn, DateTime? timeOut) {
    if (timeIn == null || timeOut == null) return timeOut;

    final maxAllowedTimeOut = DateTime(
      timeIn.year,
      timeIn.month,
      timeIn.day,
      17, // 5 PM
      0,
      0,
    );

    return timeOut.isAfter(maxAllowedTimeOut) ? maxAllowedTimeOut : timeOut;
  }

  Duration? _calculateBusinessCappedDuration(DateTime? timeIn, DateTime? timeOut) {
    if (timeIn == null) return null;

    final effectiveTimeOut = _clampTimeOutTo5Pm(timeIn, timeOut);
    if (effectiveTimeOut == null) return null;
    if (effectiveTimeOut.isBefore(timeIn)) return null;

    final rawDuration = effectiveTimeOut.difference(timeIn);
    const maxDuration = Duration(hours: 5);

    return rawDuration > maxDuration ? maxDuration : rawDuration;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDurationCsv(Duration? d) {
    if (d == null) return '';
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  String _formatDateTimeCsv(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MM/dd/yyyy hh:mm a').format(dt);
  }


}
