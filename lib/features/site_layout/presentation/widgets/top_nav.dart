// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
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
      automaticallyImplyLeading: false, // 👈 hides default back button
      title: Obx(()=>Padding(padding: EdgeInsets.only(top: 24), child: Row(
        children: [
          CustomText(text: MenController.instance.returnRouteName(), weight: FontWeight.w500,),
          Expanded(child: Container()),
          CustomText(
              text: FirebaseAuth.instance.currentUser == null ? null.toString() : FirebaseAuth.instance.currentUser!.email,
              size: 14,
              color: AppColors.black,
              weight: FontWeight.bold),

        ],),)),

      iconTheme: IconThemeData(color: AppColors.purple),
      backgroundColor: AppColors.white,

    );