import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

class SettingsHorizontalMenuItem extends StatelessWidget {
  final String? itemName;
  final Function()? onTap;

  SettingsHorizontalMenuItem({this.itemName, this.onTap, super.key});

  final settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap!,
        onHover: (value) {
          value
              ? settingsController.onHover(itemName!)
              : settingsController.onHover("not hovering");
        },
        child: Obx(() =>
            Container(
                color: settingsController.isHovering(itemName!)
                    ? Colors.grey.withOpacity(.1)
                    : Colors.transparent,
                child: Row(
                  children: [

                    Padding(
                      padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0, left: 8.0),
                      child: settingsController.returnIconFor(itemName!),
                    ),

                    if(!settingsController.isActive(itemName!))
                      Flexible(
                          child: CustomText(
                            text: itemName!,
                            color: settingsController.isHovering(itemName!) ? AppColors.black : AppColors.grey[700],
                            weight: FontWeight.normal,
                            size: 16,
                          ))
                    else
                      Flexible(
                          child: CustomText(
                            text: itemName!,
                            color: AppColors.black,
                            size: 18,
                            weight: FontWeight.bold,
                          ))

                  ],
                ))        ));
  }
}
