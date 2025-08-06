import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';

class AddCourseButton extends StatelessWidget {
  const AddCourseButton({super.key, required this.coursesController});

  final CoursesController coursesController;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Get.dialog(
          AlertDialog(
            title: Text("Add a course"),
            content: Column(
              children: [
                CustomFormField(
                  hint: "Course name",
                  textEditingController: coursesController.courseNameTEC,
                ),
                CustomFormField(
                  hint: "Course code",
                  textEditingController: coursesController.courseCodeTEC,
                ),
                CustomFormField(
                  hint: "Course category",
                  textEditingController: coursesController.courseCodeTEC,
                ),

                CustomButton(onPressed: (){}, text: "Add course")
              ],
            ),
          )
        );
      },
      child: Row(
        children: [
          Icon(Icons.add, color: AppColors.white,),
          SizedBox(width: 8),
          CustomText(text: "Add Course", weight: FontWeight.w600, color: AppColors.white,),
        ],
      ),
    );
  }
}
