import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_model.dart';

abstract class StudentRepo {
  Future<List<StudentLoginHistory>> getStudentLogs(); //for new user
  Future<List<Student>> getStudents(); //for new user
}