import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class AddTutorButton extends StatelessWidget {
  const AddTutorButton({super.key, required this.tutorsController});

  final TutorsController tutorsController;

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
                      hint: "Name",
                      textEditingController: tutorsController.nameTEC,
                    ),
                    CustomFormField(
                      hint: "Email address",
                      textInputType: TextInputType.emailAddress,
                      textEditingController: tutorsController.emailAddressTEC,
                    ),

                    CustomButton(
                      onPressed: () async {
                        await tutorsController.addTutor();
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
            text: "Add Tutor",
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
