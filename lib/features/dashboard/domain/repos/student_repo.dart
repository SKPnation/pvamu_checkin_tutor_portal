import 'package:pvamu_checkin_tutor_portal/features/dashboard/data/models/student_model.dart';

abstract class StudentRepo {
  Future<List<Student>> getStudentLogs(); //for new user
}