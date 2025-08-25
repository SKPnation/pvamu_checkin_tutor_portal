import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/presentation/controllers/auth_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/presentation/controllers/student_logs_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class AllControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => CoursesController());
    Get.lazyPut(() => StudentLogsController());
    Get.lazyPut(() => TutorsController());
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => SettingsController());
  }
}

