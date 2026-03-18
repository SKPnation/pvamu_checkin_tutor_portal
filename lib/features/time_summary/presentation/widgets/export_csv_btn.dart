import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/time_summary/presentation/controllers/time_summary_controller.dart';

class ExportCsvButton extends StatelessWidget {
  const ExportCsvButton({super.key, required this.timeSummaryCtrl});

  final TimeSummaryController timeSummaryCtrl;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: ()=> timeSummaryCtrl.exportTutorRollUpsCsv(),
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
