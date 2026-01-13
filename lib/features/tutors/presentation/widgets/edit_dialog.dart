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
  Widget build(BuildContext context) {
    return Obx(() {
      // selectedTutor is Rx<Tutor>? in your current setup
      final rxTutor = widget.tutorsController.selectedTutor;

      if (rxTutor == null) {
        return const Center(child: CircularProgressIndicator());
      }

      final Tutor tutor = rxTutor.value;

      // 1) Known weekday order
      const weekdayOrder = <String>[
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday',
      ];

      // 2) Get a non-null schedule map (string->dynamic)
      final Map<String, dynamic> schedule =
          (tutor.workSchedule as Map?)?.map(
                (k, v) => MapEntry(k.toString(), v),
          ) ??
              <String, dynamic>{};

      // 3) Build & sort safely
      final entries = schedule.entries.toList()
        ..sort((a, b) {
          final ak = a.key.toLowerCase();
          final bk = b.key.toLowerCase();

          int ai = weekdayOrder.indexOf(ak);
          int bi = weekdayOrder.indexOf(bk);

          if (ai == -1) ai = 999;
          if (bi == -1) bi = 999;

          return ai.compareTo(bi);
        });

      return AlertDialog(
        backgroundColor: AppColors.white,
        title: CustomText(text: "Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

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
                CustomText(
                  text: "Work schedule",
                  size: AppFonts.baseSize + 4,
                ),
                GestureDetector(
                  onTap: () {
                    widget.tutorsController.editMode.value =
                    !widget.tutorsController.editMode.value;
                  },
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

            ///display schedule
            // if (entries.isEmpty)
            //   const Text("No schedule")
            // else
            //   Column(
            //     children: entries.map((e) {
            //       return Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(e.key),
            //           Text(e.value.toString()),
            //         ],
            //       );
            //     }).toList(),
            //   ),

            SizedBox(height: 8),

            //Work schedule section
            widget.tutorsController.editMode.value
                ? EditScheduleSection(tutorId: tutor.id!)
                : WorkScheduleSection(sortedEntries: entries),
          ],
        ),
      );
    });
  }
}
