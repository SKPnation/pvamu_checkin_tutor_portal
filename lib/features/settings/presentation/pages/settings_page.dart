import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/add_admin_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/settings_side_menu.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final settingsController = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24),
      child: Row(
        children: [
          Expanded(flex:1, child: SettingsSideMenu()),

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  width: 200,
                  child: AddAdminButton(settingsController: settingsController),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
