import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/local_navigator.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/navigation_controller.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/responsiveness.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/large_screen.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/top_nav.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/presentation/controllers/student_logs_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class SiteLayout extends StatelessWidget {
  SiteLayout({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // final navigationController = Get.put(NavigationController());
  // final menuController = Get.put(menuController());

  final navigationController = NavigationController.instance;
  // final menController = MenController.instance;
  // final dashboardController = DashboardController.instance;

  final menController = Get.put(MenController(), permanent: true);
  final dashboardController = Get.put(DashboardController(), permanent: true);
  final coursesController = Get.put(CoursesController(), permanent: true);
  final tutorsController = Get.put(TutorsController(), permanent: true);
  final studentLogsController = Get.put(StudentLogsController(), permanent: true);


  @override
  Widget build(BuildContext context) {
    // print(menuController.activePageRoute.value);
    // User user = UserModel.fromJson(userDataStore.user);
    return Scaffold(
      key: scaffoldKey,
      extendBodyBehindAppBar: true,
      // appBar: topNavigationBar(context, scaffoldKey, "Admin"),
      // drawer: Drawer(child: SideMenu()),
      body: ResponsiveWidget(
        largeScreen: LargeScreen(scaffoldKey: scaffoldKey,),
        smallScreen: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: localNavigator(),
        ),
      ),
    );
  }
}
