import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/fonts.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/edit_schedule.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/work_schedule.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({
    super.key,
    required this.tutorId,
    required this.tutorsController,
  });

  final String tutorId;
  final TutorsController tutorsController;

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  void initState() {
    super.initState();
    widget.tutorsController.getSelectedTutorProfile(widget.tutorId);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Tutor? tutor = widget.tutorsController.selectedTutor.value;

      if (tutor == null) {
        return const Center(child: CircularProgressIndicator());
      }

      const weekdayOrder = <String>[
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday',
      ];

      final Map<String, dynamic> schedule =
          (tutor.workSchedule as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v),
          ) ??
          <String, dynamic>{};

      final entries =
          schedule.entries.toList()..sort((a, b) {
            int ai = weekdayOrder.indexOf(a.key.toLowerCase());
            int bi = weekdayOrder.indexOf(b.key.toLowerCase());
            if (ai == -1) ai = 999;
            if (bi == -1) bi = 999;
            return ai.compareTo(bi);
          });

      return AlertDialog(
        backgroundColor: AppColors.white,
        title: CustomText(text: "Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "${tutor.fName ?? ''} ${tutor.lName ?? ''}".trim(),
                      size: AppFonts.baseSize,
                    ),
                    const SizedBox(height: 2),
                    CustomText(text: tutor.email ?? "--"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Work schedule", size: AppFonts.baseSize + 4),
                GestureDetector(
                  onTap: () => widget.tutorsController.editMode.toggle(),
                  child: Icon(
                    widget.tutorsController.editMode.value
                        ? Icons.remove_red_eye_outlined
                        : Icons.edit,
                    color: AppColors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            widget.tutorsController.editMode.value
                ? EditScheduleSection(tutorId: tutor.id ?? "")
                : WorkScheduleSection(sortedEntries: entries),
          ],
        ),
      );
    });
  }
}
