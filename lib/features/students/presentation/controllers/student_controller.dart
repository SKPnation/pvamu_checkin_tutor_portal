import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_logs_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/students/data/repos/student_repo_impl.dart';


class StudentsController extends GetxController {
  static StudentsController get instance => Get.find();

  StudentRepoImpl studentRepo = StudentRepoImpl();

  Future<List<StudentLoginHistory>> getStudentLogs() async =>
      await studentRepo.getStudentLogs();

  Future<List<Student>> getStudents() async =>
      await studentRepo.getStudents();
}
