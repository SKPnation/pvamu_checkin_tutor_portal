import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';

class ExportCsvButton extends StatelessWidget {
  const ExportCsvButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {},
      child: Row(
        children: [
          Icon(Icons.save_alt_rounded, color: AppColors.white),
          SizedBox(width: 8),
          CustomText(
            text: "Export CSV",
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
