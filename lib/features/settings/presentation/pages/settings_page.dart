import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/local_navigator.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/add_admin_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/settings_side_menu.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final settingsController = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 24, top: 24),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Divider(thickness: 0.5),
            //Current page title
            // Container(
            //     margin: const EdgeInsets.only(top: 80, bottom: 20),
            //     alignment: Alignment.centerLeft,
            //     child: CustomText(
            //       text: "menuController.returnRouteName()",
            //       size: 24,
            //       weight: FontWeight.w600,
            //     )),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex:1, child: SettingsSideMenu()),
                SizedBox(width: 8),
                Expanded(flex: 5, child: settingsNavigator()),
              ],
            )
          ],
        ),
      ),
    );


  }
}

//Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   SizedBox(
//                     height: 60,
//                     width: 200,
//                     child: AddAdminButton(settingsController: settingsController),
//                   ),
//                 ],
//               ),