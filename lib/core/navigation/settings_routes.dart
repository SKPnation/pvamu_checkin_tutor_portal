import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/app_routes.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/repos/user_data_store.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/pages/tabs/general_tab.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/pages/tabs/security_tab.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/pages/tabs/team_management_tab.dart';

class SettingsRoutes {
  static const generalDisplayName = AppStrings.generalSettingsTitle;
  static const generalRoute = "/general";

  static const securityDisplayName = AppStrings.securitySettingsTitle;
  static const securityRoute = "/security";

  static const teamManagementDisplayName = AppStrings.teamManagementTitle;
  static const teamManagementRoute = "/team-management";

  static List<MenuItem> sideMenuItemRoutes = [
    MenuItem(SettingsRoutes.generalDisplayName, SettingsRoutes.generalRoute),
    MenuItem(SettingsRoutes.securityDisplayName, SettingsRoutes.securityRoute),

      MenuItem(
        SettingsRoutes.teamManagementDisplayName,
        SettingsRoutes.teamManagementRoute,
      ),
  ];

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case generalRoute:
        return _getPageRoute(GeneralTab());
      case securityRoute:
        return _getPageRoute(SecurityTab());
      case teamManagementRoute:
        return _getPageRoute(TeamManagementTab());
      default:
        return _getPageRoute(GeneralTab());
    }
  }

  static PageRoute _getPageRoute(Widget child) {
    return MaterialPageRoute(builder: (context) => child);
  }
}
