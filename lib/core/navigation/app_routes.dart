//part of app_pages;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/data/local/get_store.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/pages/courses_page.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/pages/dashboard.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/pages/site_layout.dart';

abstract class AppPages {
  AppPages._();

  // static final bool isLoggedIn = getStore.get('isLoggedIn') ?? false;

  static final String initial = Routes.rootRoute;

  // static final String initial = isLoggedIn
  //     ? Routes.rootRoute
  //     : Routes.authenticationPageRoute;

  static final pages = [
    GetPage(name: Routes.rootRoute, page: () => SiteLayout()),
    //remember to add middleware
  ];

  static final List<Widget> menuPages = [
    Dashboard(),
    const CoursesPage(),
  ];
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.dashboardRoute:
      return _getPageRoute(Dashboard());
    case Routes.coursesRoute:
      return _getPageRoute(CoursesPage());
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
];
