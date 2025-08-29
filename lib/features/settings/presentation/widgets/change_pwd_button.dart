import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

class ChangePwdButton extends StatelessWidget {
  const ChangePwdButton({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        //..
      },
      child: CustomText(
        text: "Change password",
        weight: FontWeight.w600,
        color: AppColors.white,
      ),

    );
  }
}
