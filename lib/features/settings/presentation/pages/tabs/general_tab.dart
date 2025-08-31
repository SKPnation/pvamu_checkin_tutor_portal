import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/widgets/edit_profile_container.dart';

class GeneralTab extends StatelessWidget {
  GeneralTab({super.key});

  final settingsController = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "General settings", weight: FontWeight.bold),
          CustomText(
            text: "Profile and account settings or your admin panel account",
            color: AppColors.grey[700],
          ),

          SizedBox(height: 24),

          EditProfileContainer(settingsController: settingsController)
        ],
      ),
    );
  }
}
