// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/image_elements.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/responsiveness.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/controllers/menu_controller.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key, String username) =>
    AppBar(
      // leading: !ResponsiveWidget.isSmallScreen(context)
      //     ?
      // SizedBox()
      //     :
      // IconButton(
      //   icon: Icon(Icons.menu, color: AppColors.purple),
      //   onPressed: (){
      //     key.currentState!.openDrawer();
      //   },
      // ),
      title: Obx(()=>Padding(padding: EdgeInsets.only(top: 24), child: Row(
        children: [
          CustomText(text: MenController.instance.returnRouteName(), weight: FontWeight.w500,),
          Expanded(child: Container()),

          // Container(
          //   width: 1,
          //   height: 22,
          //   color: Colors.grey,
          // ),
          //
          // SizedBox(
          //   width: 24,
          // ),

          CustomText(
              text: "Admin",
              size: 14,
              color: AppColors.black,
              weight: FontWeight.normal),

        ],),)),

      iconTheme: IconThemeData(color: AppColors.purple),
      backgroundColor: AppColors.white,

    );