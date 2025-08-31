import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/repos/user_data_store.dart';

class AppStrings{
  static const String dashboardTitle = "Dashboard";
  static const String coursesTitle = "Courses";
  static const String tutorsTitle = "Tutors";
  static const String assignedTutorsTitle = "Assigned Tutors";
  static const String settingsDisplayTitle = "Settings";
  static const String logoutTitle = "Log out";

  static const String generalSettingsTitle = "General";
  static const String securitySettingsTitle = "Security";
  static const String teamManagementTitle = "Team management";

  static const String loginTitle = "Login";
  static const String welcomeBackMsg = "Welcome back to the admin panel.";
  static const mustBePvamuEmail = "Must be a PVAMU email address";

  static const String slogan = "Excellence Lives Here";
  static const String appTitle = "CE COMMONS DASHBOARD";

  // static int adminLevel = AdminUser.fromMap(userDataStore.user).level!;
}