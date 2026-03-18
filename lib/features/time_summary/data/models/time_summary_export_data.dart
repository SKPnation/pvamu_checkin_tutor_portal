import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_logs_model.dart';

class TimeSummaryExportData {
  final List<StudentLoginHistory> studentLogs;
  final List<TutorLoginHistory> tutorLogs;

  const TimeSummaryExportData({
    required this.studentLogs,
    required this.tutorLogs,
  });
}