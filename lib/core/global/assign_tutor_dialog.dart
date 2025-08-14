import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/assign_course_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/assign_tutor_field.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class AssignTutorDialog extends StatefulWidget {
  const AssignTutorDialog({
    super.key,
    required this.coursesController,
    required this.tutorsController,
    this.tutorId,
  });

  final CoursesController coursesController;
  final TutorsController tutorsController;
  final String? tutorId;

  @override
  State<AssignTutorDialog> createState() => _AssignTutorDialogState();
}

class _AssignTutorDialogState extends State<AssignTutorDialog> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Text('Assign Tutor'),
          content: Column(
            children: [
              AssignCourseField(
                coursesController: widget.coursesController,
                onChanged: () => setDialogState(() {}),
              ),
              SizedBox(height: 8),

              widget.tutorId != null
                  ? SizedBox()
                  : AssignTutorField(
                    tutorsController: widget.tutorsController,
                    onChanged: () => setDialogState(() {}),
                  ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),

            TextButton(
              onPressed: () {
                widget.tutorsController.assignToCourse(
                  courseId: widget.coursesController.selectedCourse!.value.id!,
                  tutorId: widget.tutorId ?? widget.tutorsController.selectedTutor!.value.id!,
                );
              },
              child: const Text('Assign'),
            ),
          ],
        );
      },
    );
  }

  void Function()? onPressed() {
    if (widget.tutorId != null &&
        widget.coursesController.selectedCourse != null) {
      return () async {
        await widget.tutorsController.assignToCourse(
          courseId: widget.coursesController.selectedCourse!.value.id!,
          tutorId: widget.tutorId!,
        );

        setState(() {});
      };
    } else if (widget.coursesController.selectedCourse != null &&
        widget.tutorsController.selectedTutor != null) {
      return () async {
        await widget.tutorsController.assignToCourse(
          courseId: widget.coursesController.selectedCourse!.value.id!,
          tutorId: widget.tutorsController.selectedTutor!.value.id!,
        );

        setState(() {});
      };
    } else if (widget.coursesController.selectedCourse == null ||
        (widget.tutorsController.selectedTutor == null &&
            widget.tutorId == null)) {
      return null;
    }
    return null;
  }
}
