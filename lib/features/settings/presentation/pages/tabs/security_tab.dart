import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/change_pwd_container.dart';

class SecurityTab extends StatelessWidget {
  SecurityTab({super.key});

  final settingsController = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: "Security settings", weight: FontWeight.bold),
        CustomText(
          text: "Monitor your panel security, make security changes.",
          color: AppColors.grey[700],
        ),

        SizedBox(height: 24),

        ChangePwdContainer(settingsController: settingsController)
      ],
    ),);
  }
}
