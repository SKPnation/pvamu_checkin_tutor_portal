import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

class ChangePwdButton extends StatelessWidget {
  const ChangePwdButton({super.key, required this.settingsController, this.onPressed});

  final SettingsController settingsController;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: CustomText(
        text: "Change password",
        weight: FontWeight.w600,
        color: AppColors.white,
      ),

    );
  }
}
