import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({
    super.key,
    required this.tutorsController,
    required this.tutorId,
  });

  final String tutorId;
  final TutorsController tutorsController;

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  void initState() {
    super.initState();
    widget.tutorsController.getSelectedTutorProfile(widget.tutorId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: CustomText(
          text:
              "Delete ${widget.tutorsController.selectedTutor.value!.fName}'s profile",
        ),
        content: CustomText(text: "Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: CustomText(text: "No"),
          ),
          TextButton(
            onPressed: () async {
              await widget.tutorsController.delete(tutorId: widget.tutorId);
              widget.tutorsController.getTutors();

              Get.back();
            },
            child: CustomText(text: "Yes", color: AppColors.red),
          ),
        ],
      );
    });
  }
}
