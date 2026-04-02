import 'package:fl_chart/src/chart/base/axis_chart/axis_chart_data.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/duration_cap_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_export_data.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_metrics.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_response.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/domain/repos/time_summary_repo.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';

// assumes you already have these in your project:
// - TimeSummaryRepo
// - TimeSummaryKpis
// - DateRangeX
// - StudentLoginHistory (with fromMapAsync)
// - TutorLoginHistory (with fromMap)
// - extensions StudentLoginHistoryX / TutorLoginHistoryX (duration(), isTutorSession)

class TimeSummaryRepoImpl implements TimeSummaryRepo {
  final CollectionReference<Map<String, dynamic>> studentHistoryCollection =
  FirebaseFirestore.instance.collection('student_login_history');

  final CollectionReference<Map<String, dynamic>> tutorHistoryCollection =
  FirebaseFirestore.instance.collection('tutor_login_history');

  @override
  Future<TimeSummaryResponse> getTimeSummary({
    required DateRangeX range,
    bool includeOngoing = false,
  }) async {
    final studentQuery = studentHistoryCollection
        .where('time_in', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('time_in', isLessThanOrEqualTo: Timestamp.fromDate(range.endInclusive));

    final tutorQuery = tutorHistoryCollection
        .where('time_in', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('time_in', isLessThanOrEqualTo: Timestamp.fromDate(range.endInclusive));

    final results = await Future.wait([studentQuery.get(), tutorQuery.get()]);

    final studentSnap = results[0];
    final tutorSnap = results[1];

    final studentLogs = await Future.wait(
      studentSnap.docs.map((doc) => StudentLoginHistory.fromMapAsync(doc.data(), doc.id)),
    );

    final tutorLogs = tutorSnap.docs
        .map((doc) => TutorLoginHistory.fromMap(doc.data(), doc.id))
        .toList();

    // KPIs
    final kpis = TimeSummaryKpis.fromLists(
      studentLogins: studentLogs,
      tutorLogins: tutorLogs,
      range: range,
      includeOngoing: includeOngoing,
    );

    // Chart spots (daily for <= 35 days, monthly otherwise)
    final bool monthly = range.endInclusive.difference(range.start).inDays > 35;

    final studentSpots = buildSpotsFromStudents(
      studentLogs,
      range: range,
      includeOngoing: includeOngoing,
      monthly: monthly,
    );

    final tutorSpots = buildSpotsFromTutors(
      tutorLogs,
      range: range,
      includeOngoing: includeOngoing,
      monthly: monthly,
    );

    final topTutors = TutorHoursRollup.build(
      tutorLogins: tutorLogs,
      range: range,
      includeOngoing: includeOngoing,
    );

    return TimeSummaryResponse(
      kpis: kpis,
      studentSpots: studentSpots,
      tutorSpots: tutorSpots,
      topTutors: topTutors,
    );
  }

  @override
  List<FlSpot> buildSpotsFromStudents(List<StudentLoginHistory> logs, {required DateRangeX range, required bool includeOngoing, required bool monthly}) {
    final Map<int, double> buckets = {};

    for (final s in logs) {
      final dt = s.timeIn;
      if (dt == null) continue;
      if (!range.contains(dt)) continue;

      final d = s.duration(includeOngoing: includeOngoing);
      if (d == null) continue;

      final hours = d.inMinutes / 60.0;
      final key = monthly ? (dt.month) : dayIndex(dt, range.start); // x-axis
      buckets[key] = (buckets[key] ?? 0) + hours;
    }

    final spots = buckets.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return spots;
  }

  @override
  List<FlSpot> buildSpotsFromTutors(
      List<TutorLoginHistory> logs, {
        required DateRangeX range,
        required bool includeOngoing,
        required bool monthly,
      }) {
    final Map<int, double> buckets = {};

    final dedupedLogs = TutorHoursRollup.dedupeTutorLogs(logs);

    for (final t in dedupedLogs) {
      final dt = t.timeIn;
      if (dt == null) continue;
      if (!range.contains(dt)) continue;

      final d = calculateTutorBusinessCappedDuration(
        timeIn: t.timeIn,
        timeOut: t.timeOut,
        includeOngoing: includeOngoing,
      );
      if (d == null) continue;

      final hours = d.inMinutes / 60.0;
      final key = monthly ? dt.month : dayIndex(dt, range.start);
      buckets[key] = (buckets[key] ?? 0) + hours;
    }

    final spots = buckets.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return spots;
  }

  @override
  int dayIndex(DateTime dt, DateTime start) {
    final d0 = DateTime(start.year, start.month, start.day);
    final d1 = DateTime(dt.year, dt.month, dt.day);
    return d1.difference(d0).inDays;
  }

  @override
  Future<TimeSummaryExportData> getExportData({required DateRangeX range, bool includeOngoing = false}) async {
    final studentQuery = studentHistoryCollection
        .where('time_in', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('time_in', isLessThanOrEqualTo: Timestamp.fromDate(range.endInclusive));

    final tutorQuery = tutorHistoryCollection
        .where('time_in', isGreaterThanOrEqualTo: Timestamp.fromDate(range.start))
        .where('time_in', isLessThanOrEqualTo: Timestamp.fromDate(range.endInclusive));

    final results = await Future.wait([
      studentQuery.get(),
      tutorQuery.get(),
    ]);

    final studentSnap = results[0];
    final tutorSnap = results[1];

    final studentLogs = await Future.wait(
      studentSnap.docs.map((doc) => StudentLoginHistory.fromMapAsync(doc.data(), doc.id)),
    );

    final tutorLogs = tutorSnap.docs
        .map((doc) => TutorLoginHistory.fromMap(doc.data(), doc.id))
        .toList();

    return TimeSummaryExportData(
      studentLogs: studentLogs,
      tutorLogs: tutorLogs,
    );
  }
}