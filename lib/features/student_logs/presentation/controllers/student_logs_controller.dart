import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/data/models/student_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/data/repos/student_repo_impl.dart';

class StudentLogsController extends GetxController {
  static StudentLogsController get instance => Get.find();

  StudentRepoImpl studentRepo = StudentRepoImpl();

  Future<List<Student>> getStudentLogs() async =>
      await studentRepo.getStudentLogs();
}
