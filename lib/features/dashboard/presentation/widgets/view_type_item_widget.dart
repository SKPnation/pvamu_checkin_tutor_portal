import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/fonts.dart';
import 'package:pvamu_checkin_tutor_portal/features/dashboard/presentation/controllers/dashboard_controller.dart';

class ViewTypeItemWidget extends StatelessWidget {
  const ViewTypeItemWidget({
    super.key,
    required this.type,
    this.onTap,
    required this.dashboardController,
  });

  final String type;
  final Function()? onTap;
  final DashboardController dashboardController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(
        () => Column(
          children: [
            CustomText(text: type, size: AppFonts.baseSize),
            dashboardController.viewIndex.value ==
                    dashboardController.views.indexOf(type)
                ? Container(height: 2, width: 100, color: AppColors.gold)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
