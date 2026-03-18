import 'package:fl_chart/fl_chart.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_export_data.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_metrics.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/data/models/time_summary_response.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';

abstract class TimeSummaryRepo {
  Future<TimeSummaryResponse> getTimeSummary({
    required DateRangeX range,
    bool includeOngoing = false,
  });

  Future<TimeSummaryExportData> getExportData({
    required DateRangeX range,
    bool includeOngoing = false,
  });

  List<FlSpot> buildSpotsFromStudents(
    List<StudentLoginHistory> logs, {
    required DateRangeX range,
    required bool includeOngoing,
    required bool monthly,
  });

  List<FlSpot> buildSpotsFromTutors(
      List<TutorLoginHistory> logs, {
        required DateRangeX range,
        required bool includeOngoing,
        required bool monthly,
      });

  int dayIndex(DateTime dt, DateTime start) {
    final d0 = DateTime(start.year, start.month, start.day);
    final d1 = DateTime(dt.year, dt.month, dt.day);
    return d1.difference(d0).inDays;
  }
}
