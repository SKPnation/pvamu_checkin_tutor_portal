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

  factory DateRangeX.last2Weeks() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final start = end.subtract(const Duration(days: 13));
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
    final dedupedLogs = dedupeTutorLogs(tutorLogins);

    final map = <String, TutorAgg>{};

    for (final t in dedupedLogs) {
      final sessionDate = t.timeIn ?? t.createdAt;
      if (sessionDate == null || !range.contains(sessionDate)) continue;

      final id = t.tutorId ?? t.tutorRef?.id;
      if (id == null || id.isEmpty) continue;

      map.putIfAbsent(
        id,
            () => TutorAgg(
          name: t.tutorName,
          email: t.tutorEmail,
        ),
      );

      final agg = map[id]!;

      final capped = _cappedDuration(
        timeIn: t.timeIn,
        timeOut: t.timeOut,
        includeOngoing: includeOngoing,
      );

      if (capped == null || capped <= Duration.zero) continue;

      agg.count++;
      agg.dur += capped;

      final candidate = t.timeIn ?? t.createdAt;
      if (candidate != null &&
          (agg.lastActive == null || candidate.isAfter(agg.lastActive!))) {
        agg.lastActive = candidate;
      }

      agg.name ??= t.tutorName;
      agg.email ??= t.tutorEmail;
    }

    final list = map.entries.map((e) {
      final agg = e.value;

      final avg = agg.count == 0
          ? null
          : Duration(
        minutes: (agg.dur.inMinutes / agg.count).round(),
      );

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

  static Duration? _cappedDuration({
    required DateTime? timeIn,
    required DateTime? timeOut,
    required bool includeOngoing,
  }) {
    if (timeIn == null) return null;

    final end = timeOut ?? (includeOngoing ? DateTime.now() : null);
    if (end == null || end.isBefore(timeIn)) return null;

    final raw = end.difference(timeIn);
    const maxDuration = Duration(hours: 5);

    return raw > maxDuration ? maxDuration : raw;
  }

  static List<TutorLoginHistory> dedupeTutorLogs(List<TutorLoginHistory> logs) {
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
      if (lastSeen != null &&
          lastSeen.difference(stamp).inSeconds.abs() <= 60) {
        continue;
      }

      lastSeenByTutor[tutorId] = stamp;
      unique.add(log);
    }

    return unique;
  }
}

class TutorAgg {
  String? name;
  String? email;
  int count = 0;
  Duration dur = Duration.zero;
  DateTime? lastActive;

  TutorAgg({
    this.name,
    this.email,
  });
}

