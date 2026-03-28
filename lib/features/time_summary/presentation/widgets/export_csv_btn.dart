import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/controllers/time_summary_controller.dart';

class ExportCsvButton extends StatelessWidget {
  const ExportCsvButton({super.key, this.onPressed, required this.text});

  final Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(Icons.save_alt_rounded, color: AppColors.white),
          SizedBox(width: 8),
          CustomText(
            text: text,
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
