import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/assign_tutor_dialog.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class AssignTutorButton extends StatelessWidget {
  const AssignTutorButton({super.key, required this.coursesController, required this.tutorsController, this.from});

  final CoursesController coursesController;
  final TutorsController tutorsController;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Get.dialog(
          AssignTutorDialog(
            coursesController: coursesController,
            tutorsController: tutorsController,
            from: from,
          ),
        );
      },
      child: Row(
        children: [
          Icon(Icons.people, color: AppColors.white,),
          SizedBox(width: 8),
          CustomText(text: "Assign Tutor", weight: FontWeight.w600, color: AppColors.white,),
        ],
      ),
    );
  }
}
