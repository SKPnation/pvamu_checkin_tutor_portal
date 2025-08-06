// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';

class HorizontalMenuItem extends StatelessWidget {
  final String? itemName;
  final Function()? onTap;

  HorizontalMenuItem({this.itemName, this.onTap, super.key});

  final menuController = Get.put(MenController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap!,
        onHover: (value){
          value
              ? menuController.onHover(itemName!)
              : menuController.onHover("not hovering");
          },
        child: Obx(() =>
            Container(
            color: menuController.isHovering(itemName!)
                ? Colors.grey.withOpacity(.1)
                : Colors.transparent,
            child: Row(
              children: [

                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: menuController.returnIconFor(itemName!),
                ),

                if(!menuController.isActive(itemName!))
                  Flexible(
                      child: CustomText(
                        text: itemName!,
                        color: menuController.isHovering(itemName!) ? AppColors.white : AppColors.grey[900],
                        weight: FontWeight.normal,
                        size: 16,
                      ))
                else
                  Flexible(
                      child: CustomText(
                        text: itemName!,
                        color: AppColors.white,
                        size: 18,
                        weight: FontWeight.bold,
                      ))

              ],
            ))
        )

    );
  }
}