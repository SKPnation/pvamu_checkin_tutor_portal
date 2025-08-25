import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

class AddAdminButton extends StatelessWidget {
  const AddAdminButton({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Get.dialog(
          StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: AppColors.white,
                title: Text("Add a tutor"),
                content: Column(
                  children: [
                    CustomFormField(
                      hint: "First name",
                      textEditingController: settingsController.firstNameTEC,
                    ),
                    SizedBox(height: 8),
                    CustomFormField(
                      hint: "Last name",
                      textEditingController: settingsController.lastNameTEC,
                    ),

                    CustomFormField(
                      hint: "Email address",
                      textInputType: TextInputType.emailAddress,
                      textEditingController: settingsController.emailAddressTEC,
                    ),

                    CustomFormField(
                      hint: "Password",
                      textInputType: TextInputType.visiblePassword,
                      textEditingController: settingsController.passwordTEC,
                    ),

                    CustomButton(
                      onPressed: () async {
                        await settingsController.addAdminUser();
                      },
                      text: "Add tutor",
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      child: Row(
        children: [
          Icon(Icons.add, color: AppColors.white),
          SizedBox(width: 8),
          CustomText(
            text: "Add Admin User",
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
