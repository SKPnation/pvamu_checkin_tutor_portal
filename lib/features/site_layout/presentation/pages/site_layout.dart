import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/local_navigator.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/navigation_controller.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/responsiveness.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/large_screen.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/top_nav.dart';

class SiteLayout extends StatelessWidget {
  SiteLayout({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final navigationController = Get.put(NavigationController());
  final menuController = Get.put(MenController());

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
