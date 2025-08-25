import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/responsiveness.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

import 'package:pvamu_checkin_tutor_portal/core/navigation/settings_routes.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/settings_side_menu_item.dart';

class SettingsSideMenu extends StatelessWidget {
  SettingsSideMenu({super.key});

  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: SettingsRoutes.sideMenuItemRoutes
            .map(
              (item) => SettingsSideMenuItem(
              itemName: item.name,
              onTap: () {
                if (!settingsController.isActive(item.name)) {
                  settingsController
                      .changeActiveItemTo(item.name);
                  if (ResponsiveWidget.isSmallScreen(context)) {
                    Get.back();
                  }

                  settingsController.navigateTo(item.route);
                }
              }),
        )
            .toList());
  }
}
