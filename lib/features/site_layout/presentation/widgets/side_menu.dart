import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/app_routes.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/navigation_controller.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/image_elements.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/responsiveness.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/side_menu_item.dart';

class SideMenu extends StatelessWidget {
  final menController = Get.put(MenController());
  final navigationController = Get.put(NavigationController());

  final GlobalKey<ScaffoldState> scaffoldKey;

  SideMenu({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey[600],
      child: ListView(
        children: [
          !ResponsiveWidget.isSmallScreen(context)
              ? Padding(
            padding: EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Image.asset(ImageElements.pvamuLogo, height: 80, width: 80),
                    SizedBox(width: 16),
                    Expanded(child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.white, // Gold
                          AppColors.gold,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: CustomText(
                        text: "Check-In",
                        color: Colors.white, // Important: must be set, even if overridden
                        size: 24,
                        weight: FontWeight.w600,
                      ),
                    )),
                  ],
                ),
              )
              : IconButton(
                icon: Icon(Icons.menu, color: AppColors.white),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),

                Row(
                  children: [
                    SizedBox(width: displayWidth(context) / 48),
                    Image.asset(ImageElements.pvamuLogo, height: 70, width: 70),
                    Flexible(
                      child: CustomText(
                        text: "Check-in",
                        size: 20,
                        weight: FontWeight.bold,
                        color: AppColors.purple,
                      ),
                    ),
                    SizedBox(width: displayWidth(context) / 48),
                  ],
                ),
              ],
            ),

          if (ResponsiveWidget.isSmallScreen(context))
            Divider(color: AppColors.grey[100], thickness: 0.25,),


          Divider(color: AppColors.grey[100], thickness: 0.25,),


          Column(
            mainAxisSize: MainAxisSize.min,
            children:
                sideMenuItemRoutes
                    .map(
                      (item) => SideMenuItem(
                        itemName: item.name,
                        onTap: () async {
                          // if(item.route == Routes.authenticationPageRoute){
                          //  bool signOut = await authController.signOut();
                          //  menController.changeActiveItemTo(item.name, item.route);
                          //
                          //  if(signOut){
                          //    Get.offAllNamed(Routes.authenticationPageRoute);
                          //    getStore.clearAllData();
                          //  }
                          // }

                          if (!menController.isActive(item.name)) {
                            menController.changeActiveItemTo(
                              item.name,
                              item.route,
                            );
                            if (ResponsiveWidget.isSmallScreen(context)) {
                              Get.back();
                            }
                            navigationController.navigateTo(item.route);
                          }
                        },
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
