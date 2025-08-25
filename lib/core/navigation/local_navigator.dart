import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/app_routes.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/navigation_controller.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/settings_routes.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';

NavigationController navigationController = NavigationController.instance;
SettingsController settingsController = SettingsController.instance;

Navigator localNavigator() => Navigator(
  key: navigationController.navigatorKey,
  onGenerateRoute: generateRoute,
  initialRoute: MenController.instance.activePageRoute.value,
);

Navigator settingsNavigator() => Navigator(
  key: settingsController.settingsNavigatorKey,
  onGenerateRoute: SettingsRoutes.generateRoute,
  initialRoute: settingsController.activeItem.value,
  //Routes.dashboardRoute
);