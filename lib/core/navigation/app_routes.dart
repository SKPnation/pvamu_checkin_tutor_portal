//part of app_pages;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/data/local/get_store.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/auth_middleware.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/presentation/pages/auth_page.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/pages/settings_page.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/pages/assigned_tutors_page.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/pages/courses_page.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/pages/dashboard.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/pages/site_layout.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/pages/tutors_page.dart';

abstract class AppPages {
  AppPages._();

  // static final bool isLoggedIn = getStore.get('isLoggedIn') ?? false;

  static final String initial =
      FirebaseAuth.instance.currentUser != null
          ? Routes.rootRoute
          : Routes.authRoute;

  static final pages = [
    GetPage(
      name: Routes.rootRoute,
      page: () => SiteLayout(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(name: Routes.authRoute, page: () => AuthPage()),
    //remember to add middleware
  ];

  static final List<Widget> menuPages = [
    Dashboard(),
    CoursesPage(),
    TutorsPage(),
    AssignedTutorsPage(),
    SettingsPage(),
  ];
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.dashboardRoute:
      return _getPageRoute(Dashboard());
    case Routes.coursesRoute:
      return _getPageRoute(CoursesPage());
    case Routes.tutorsRoute:
      return _getPageRoute(TutorsPage());
    case Routes.assignedTutorsRoute:
      return _getPageRoute(AssignedTutorsPage());
    case Routes.settingsRoute:
      return _getPageRoute(SettingsPage());
    default:
      return _getPageRoute(Dashboard());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

abstract class Routes {
  Routes._();

  static const dashboardDisplayName = AppStrings.dashboardTitle;
  static const dashboardRoute = "/dashboard";

  static const coursesDisplayName = AppStrings.coursesTitle;
  static const coursesRoute = "/courses";

  static const tutorsDisplayName = AppStrings.tutorsTitle;
  static const tutorsRoute = "/tutors";

  static const assignedTutorsDisplayName = AppStrings.assignedTutorsTitle;
  static const assignedTutorsRoute = "/assigned-tutors";

  static const settingsDisplayName = AppStrings.settingsDisplayTitle;
  static const settingsRoute = "/settings";

  static const logoutDisplayName = AppStrings.logoutTitle;
  static const authRoute = "/authentication";

  static const rootRoute = "/";
}

class MenuItem {
  final String name;
  final String route;

  MenuItem(this.name, this.route);
}

List<MenuItem> sideMenuItemRoutes = [
  MenuItem(Routes.dashboardDisplayName, Routes.dashboardRoute),
  MenuItem(Routes.coursesDisplayName, Routes.coursesRoute),
  MenuItem(Routes.tutorsDisplayName, Routes.tutorsRoute),
  MenuItem(Routes.assignedTutorsDisplayName, Routes.assignedTutorsRoute),
  MenuItem(Routes.settingsDisplayName, Routes.settingsRoute),
  MenuItem(Routes.logoutDisplayName, Routes.authRoute),
];
