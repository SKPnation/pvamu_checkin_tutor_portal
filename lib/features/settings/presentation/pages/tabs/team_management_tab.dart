import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/add_admin_button.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/admin_users_table.dart';

class TeamManagementTab extends StatelessWidget {
  TeamManagementTab({super.key});

  final settingsController = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [CustomText(text: "Admin management settings", weight: FontWeight.bold,),
                CustomText(text: "Manage control and permissions in your team", color: AppColors.grey[700]),],
            ),
            SizedBox(width: 180,child: AddAdminButton(settingsController: settingsController),)
          ],
        ),

        SizedBox(height: 16),

        AdminUsersTable()

      ],
    );
  }
}
