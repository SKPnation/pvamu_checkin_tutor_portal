import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_form_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';

class AddCourseButton extends StatefulWidget {
  const AddCourseButton({super.key, required this.coursesController});

  final CoursesController coursesController;

  @override
  State<AddCourseButton> createState() => _AddCourseButtonState();
}

class _AddCourseButtonState extends State<AddCourseButton> {
  var courseNameErr = "";

  var courseCodeErr = "";

  var courseCategoryErr = "";

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Get.dialog(
          StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                backgroundColor: AppColors.white,
                title: Text("Add a course"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFormField(
                      hint: "Course code, e.g CINS 20071",
                      textCapitalization: TextCapitalization.characters,
                      textEditingController:
                          widget.coursesController.courseCodeTEC,
                    ),
                    if (courseCodeErr.isNotEmpty)
                      CustomText(text: courseCodeErr, color: AppColors.red),

                    SizedBox(height: 4),

                    CustomFormField(
                      hint: "Course name, e.g Information technology",
                      textEditingController:
                          widget.coursesController.courseNameTEC,
                    ),
                    if (courseNameErr.isNotEmpty)
                      CustomText(text: courseNameErr, color: AppColors.red),

                    SizedBox(height: 8),

                    CustomButton(
                      onPressed: () async {
                        if (widget
                                .coursesController
                                .courseCodeTEC
                                .text
                                .isEmpty &&
                            widget
                                .coursesController
                                .courseNameTEC
                                .text
                                .isEmpty) {
                          courseCodeErr = "The course code is required";
                          courseNameErr = "The course name is required";
                        } else if (widget
                            .coursesController
                            .courseNameTEC
                            .text
                            .isEmpty) {
                          courseNameErr = "The course name is required";
                          courseCodeErr = "";
                        } else if (widget
                            .coursesController
                            .courseCodeTEC
                            .text
                            .isEmpty) {
                          courseNameErr = "";
                          courseCodeErr = "The course code is required";
                        } else {
                          courseNameErr = "";
                          courseCodeErr = "";

                          await widget.coursesController.addCourse();
                        }

                        setDialogState(() {});
                      },
                      text: "Add course",
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
            text: "Add Course",
            weight: FontWeight.w600,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
