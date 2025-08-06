
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';

class AddTutorButton extends StatelessWidget {
  const AddTutorButton({super.key, required this.coursesController});

  final CoursesController coursesController;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Get.dialog(
            AlertDialog(
              title: Text("Add a tutor"),
              content: Column(
                children: [
                  CustomFormField(
                    hint: "Name",
                    textEditingController: coursesController.courseNameTEC,
                  ),
                  CustomFormField(
                    hint: "Email address",
                    textEditingController: coursesController.courseCodeTEC,
                  ),

                  CustomButton(onPressed: (){}, text: "Add tutor")
                ],
              ),
            )
        );
      },
      child: Row(
        children: [
          Icon(Icons.add, color: AppColors.white,),
          SizedBox(width: 8),
          CustomText(text: "Add Tutor", weight: FontWeight.w600, color: AppColors.white,),
        ],
      ),
    );
  }
}
