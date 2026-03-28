import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_metrics.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/repos/time_summary_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/domain/repos/time_summary_repo.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';

enum TimeSummaryPreset { last7Days, last30Days, last1Year, custom }

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

  ///EXPORT TUTOR ROLL UPS TO CSV
  Future<void> exportTutorRollUpsCsv() async {
    try {
      final rows = <List<dynamic>>[
        [
          'Tutor Name',
          'Email',
          'Total Hours',
          'Sign-ins',
          'Avg Duration',
          'Last Active',
        ],
      ];

      for (final t in tutorRollUps) {
        rows.add([
          t.tutorName ?? '',
          t.tutorEmail ?? '',
          t.hours.toStringAsFixed(1),
          t.signIns,
          _formatDurationCsv(t.avgDuration),
          _formatDateCsv(t.lastActive),
        ]);
      }

      final csv = const ListToCsvConverter().convert(rows);

      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final fileName =
          'time_summary_tutors_${DateFormat('yyyyMMdd').format(currentRange.start)}_${DateFormat('yyyyMMdd').format(currentRange.endInclusive)}.csv';

      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      error.value = 'Failed to export CSV: $e';
    }
  }


  ///TO EXPORT TUTOR LOGS TO CSV
  Future<void> exportTutorLogsToCSV() async {
    try {
      error.value = '';

      final range = currentRange;

      final snapshot =
          await TimeSummaryRepoImpl().tutorHistoryCollection
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

      final logs =
          snapshot.docs
              .map((doc) => TutorLoginHistory.fromMap(doc.data(), doc.id))
              .toList();

      final rows = <List<dynamic>>[
        [
          'Date',
          'Tutor ID',
          'Tutor Name',
          'Email',
          'Time In',
          'Time Out',
          'Session Duration',
          'Capped Session Duration'
        ],
      ];

      DateTime? lastPrintedDate;

      for (final log in logs) {
        final sessionDate = log.timeIn ?? log.createdAt;
        final duration = _calculateSessionDuration(log.timeIn, log.timeOut);
        final cappedDuration = _calculateCappedSessionDuration(log.timeIn, log.timeOut);

        final isNewDateGroup =
            sessionDate != null &&
            (lastPrintedDate == null ||
                !_isSameDate(lastPrintedDate, sessionDate));

        if (isNewDateGroup) {
          rows.add([]);
          rows.add([
            DateFormat('MM/dd/yyyy').format(sessionDate),
            '',
            '',
            '',
            '',
            '',
            '',
            ''
          ]);
          lastPrintedDate = sessionDate;
        }

        rows.add([
          '',
          log.tutorId ?? '',
          log.tutorName ?? '',
          log.tutorEmail ?? '',
          _formatDateTimeCsv(log.timeIn),
          _formatDateTimeCsv(log.timeOut),
          _formatDurationCsv(duration),
          _formatDurationCsv(cappedDuration)
        ]);
      }

      final csv = const ListToCsvConverter().convert(rows);

      final bytes = utf8.encode(csv);
      final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);

      final fileName =
          'tutor_logs_${DateFormat('yyyyMMdd').format(range.start)}_${DateFormat('yyyyMMdd').format(range.endInclusive)}.csv';

      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      error.value = 'Failed to export tutor logs CSV: $e';
    }
  }

  String _formatDurationCsv(Duration? d) {
    if (d == null) return '';
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  Duration? _calculateSessionDuration(DateTime? timeIn, DateTime? timeOut) {
    if (timeIn == null || timeOut == null) return null;
    if (timeOut.isBefore(timeIn)) return null;
    return timeOut.difference(timeIn);
  }

  Duration? _calculateCappedSessionDuration(DateTime? timeIn, DateTime? timeOut) {
    if (timeIn == null) return null;

    final end = timeOut ?? DateTime.now();
    if (end.isBefore(timeIn)) return null;

    final rawDuration = end.difference(timeIn);
    const maxDuration = Duration(hours: 5);

    return rawDuration > maxDuration ? maxDuration : rawDuration;
  }

  String _formatDateTimeCsv(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MM/dd/yyyy hh:mm a').format(dt);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatDateCsv(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MM/dd/yyyy').format(dt);
  }
}
