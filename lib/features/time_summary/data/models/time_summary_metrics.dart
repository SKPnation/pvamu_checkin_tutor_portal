import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';

/// ------------------------------
/// Extensions on the existing models
/// ------------------------------

extension StudentLoginHistoryX on StudentLoginHistory {
  /// A "student session" = student record that has a tutor attached
  bool get isTutorSession => tutor != null;

  /// Duration for this login record
  /// - if timeOut is null:
  ///   - includeOngoing=false => ignore
  ///   - includeOngoing=true  => count until now
  Duration? duration({bool includeOngoing = false}) {
    if (timeIn == null) return null;
    final end = timeOut ?? (includeOngoing ? DateTime.now() : null);
    if (end == null) return null;

    final d = end.difference(timeIn!);
    if (d.isNegative) return null;
    return d;
  }
}

extension TutorLoginHistoryX on TutorLoginHistory {
  Duration? duration({bool includeOngoing = false}) {
    if (timeIn == null) return null;
    final end = timeOut ?? (includeOngoing ? DateTime.now() : null);
    if (end == null) return null;

    final d = end.difference(timeIn!);
    if (d.isNegative) return null;
    return d;
  }
}

/// ------------------------------
/// Date range helper (7 days / 30 days / 1 year / custom)
/// ------------------------------
class DateRangeX {
  final DateTime start;
  final DateTime endInclusive;

  const DateRangeX({required this.start, required this.endInclusive});

  factory DateRangeX.last7Days() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final start = end.subtract(const Duration(days: 6));
    return DateRangeX(start: DateTime(start.year, start.month, start.day), endInclusive: end);
  }

  factory DateRangeX.last30Days() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final start = end.subtract(const Duration(days: 29));
    return DateRangeX(start: DateTime(start.year, start.month, start.day), endInclusive: end);
  }

  factory DateRangeX.last1Year() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final start = DateTime(end.year - 1, end.month, end.day);
    return DateRangeX(start: DateTime(start.year, start.month, start.day), endInclusive: end);
  }

  bool contains(DateTime? dt) {
    if (dt == null) return false;
    return !dt.isBefore(start) && !dt.isAfter(endInclusive);
  }
}

/// ------------------------------
/// KPI summary model for your Time Summary cards
/// ------------------------------
class TimeSummaryKpis {
  final Duration totalStudentHours;   // sum of student_login_history durations
  final Duration totalTutorHours;     // sum of tutor_login_history durations
  final int studentSessions;          // student records where tutor != null
  final int tutorSignIns;             // number of tutor_login_history records
  final int studentSignIns;           // number of student_login_history records
  final int totalSignIns;             // tutorSignIns + studentSignIns

  const TimeSummaryKpis({
    required this.totalStudentHours,
    required this.totalTutorHours,
    required this.studentSessions,
    required this.tutorSignIns,
    required this.studentSignIns,
    required this.totalSignIns,
  });

  /// For your cards (you can show "hrs" with decimals if you want)
  double get totalStudentHoursFloat => totalStudentHours.inMinutes / 60.0;
  double get totalTutorHoursFloat => totalTutorHours.inMinutes / 60.0;

  /// Computes KPIs from already-loaded lists (recommended)
  static TimeSummaryKpis fromLists({
    required List<StudentLoginHistory> studentLogins,
    required List<TutorLoginHistory> tutorLogins,
    required DateRangeX range,
    bool includeOngoing = false,
  }) {
    final filteredStudents = studentLogins.where((e) => range.contains(e.timeIn)).toList();
    final filteredTutors = tutorLogins.where((e) => range.contains(e.timeIn)).toList();

    Duration sumStudent = Duration.zero;
    for (final s in filteredStudents) {
      final d = s.duration(includeOngoing: includeOngoing);
      if (d != null) sumStudent += d;
    }

    Duration sumTutor = Duration.zero;
    for (final t in filteredTutors) {
      final d = t.duration(includeOngoing: includeOngoing);
      if (d != null) sumTutor += d;
    }

    final sessions = filteredStudents.where((e) => e.isTutorSession).length;

    final tutorSignIns = filteredTutors.length;
    final studentSignIns = filteredStudents.length;

    return TimeSummaryKpis(
      totalStudentHours: sumStudent,
      totalTutorHours: sumTutor,
      studentSessions: sessions,
      tutorSignIns: tutorSignIns,
      studentSignIns: studentSignIns,
      totalSignIns: tutorSignIns + studentSignIns,
    );
  }
}

/// ------------------------------
/// Optional: breakdown model for "Top Tutors by Hours"
/// ------------------------------
// 1) Update your rollup model to include lastActive + avgDuration

class TutorHoursRollup {
  final String tutorId;
  final String? tutorName;
  final String? tutorEmail;

  final Duration totalHours;
  final int signIns;

  final Duration? avgDuration;
  final DateTime? lastActive;

  const TutorHoursRollup({
    required this.tutorId,
    required this.tutorName,
    required this.tutorEmail,
    required this.totalHours,
    required this.signIns,
    required this.avgDuration,
    required this.lastActive,
  });

  double get hours => totalHours.inMinutes / 60.0;

  static List<TutorHoursRollup> build({
    required List<TutorLoginHistory> tutorLogins,
    required DateRangeX range,
    bool includeOngoing = false,
  }) {
    final map = <String, _TutorAgg>{};

    for (final t in tutorLogins) {
      if (!range.contains(t.timeIn)) continue;

      final id = t.tutorId ?? t.tutorRef?.id;
      if (id == null || id.isEmpty) continue;

      map.putIfAbsent(
        id,
            () => _TutorAgg(
          name: t.tutorName,
          email: t.tutorEmail,
        ),
      );

      final agg = map[id]!;
      agg.count++;

      final d = t.duration(includeOngoing: includeOngoing);
      if (d != null) agg.dur += d;

      // track last active using timeIn (or timeOut if you prefer)
      final candidate = t.timeIn;
      if (candidate != null) {
        if (agg.lastActive == null || candidate.isAfter(agg.lastActive!)) {
          agg.lastActive = candidate;
        }
      }

      // Keep latest snapshot values if present
      agg.name ??= t.tutorName;
      agg.email ??= t.tutorEmail;
    }

    final list = map.entries.map((e) {
      final agg = e.value;
      final avg = agg.count == 0
          ? null
          : Duration(minutes: (agg.dur.inMinutes / agg.count).round());

      return TutorHoursRollup(
        tutorId: e.key,
        tutorName: agg.name,
        tutorEmail: agg.email,
        totalHours: agg.dur,
        signIns: agg.count,
        avgDuration: avg,
        lastActive: agg.lastActive,
      );
    }).toList();

    list.sort((a, b) => b.totalHours.compareTo(a.totalHours));
    return list;
  }
}

class _TutorAgg {
  Duration dur = Duration.zero;
  int count = 0;
  String? name;
  String? email;
  DateTime? lastActive;

  _TutorAgg({this.name, this.email});
}