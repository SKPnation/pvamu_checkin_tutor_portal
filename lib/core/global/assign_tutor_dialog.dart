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
    this.from,
  });

  final CoursesController coursesController;
  final TutorsController tutorsController;
  final String? tutorId;
  final String? from;

  @override
  State<AssignTutorDialog> createState() => _AssignTutorDialogState();
}

class _AssignTutorDialogState extends State<AssignTutorDialog> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        final canAssign = widget.coursesController.selectedCourse?.value.id != null &&
            (widget.tutorId != null || widget.tutorsController.selectedTutor?.value.id != null);

        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Assign Tutor"),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
                tooltip: "return to ${widget.from} page",
              ),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 320, maxWidth: 560),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AssignCourseField(
                    coursesController: widget.coursesController,
                    onChanged: () => setDialogState(() {}),
                  ),
                  const SizedBox(height: 8),
                  if (widget.tutorId == null)
                    AssignTutorField(
                      tutorsController: widget.tutorsController,
                      onChanged: () => setDialogState(() {}),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Close')),
            TextButton(
              onPressed: canAssign
                  ? () {
                final courseId = widget.coursesController.selectedCourse!.value.id!;
                final tutorId = widget.tutorId ?? widget.tutorsController.selectedTutor!.value.id!;
                widget.tutorsController.assignToCourse(
                  courseId: courseId,
                  tutorId: tutorId,
                );
              }
                  : null, // disabled until selections exist
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
