import 'package:firebase_storage/firebase_storage.dart';
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

      print("Profile Photo URL: ${tutor.profilePhotoUrl}");
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: CustomText(text: "Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    tutor.profilePhotoUrl != null &&
                            tutor.profilePhotoUrl!.isNotEmpty
                        ? Get.dialog(
                          AlertDialog(
                            content:
                                tutor.profilePhotoUrl != null &&
                                        tutor.profilePhotoUrl!.isNotEmpty
                                    ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        tutor.profilePhotoUrl!,
                                        fit: BoxFit.cover,

                                        // Show spinner while loading
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const SizedBox(
                                            width: 120,
                                            height: 120,
                                            child: Center(
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          );
                                        },

                                        // Prevent crashes on web (CORS / network / 403)
                                        errorBuilder: (context, error, stackTrace) {
                                          debugPrint("Profile image load error: $error");
                                          return const SizedBox(
                                            width: 120,
                                            height: 120,
                                            child: Icon(
                                              Icons.person,
                                              size: 48,
                                              color: Colors.grey,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.tutorsController.deleteProfilePicture(
                                            tutor.id!,
                                            tutor.profilePhotoUrl!,
                                          );
                                          Get.back();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : const Icon(
                                      Icons.person,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                          ),
                        )
                        : widget.tutorsController.updateProfilePicture(
                          tutor.id!,
                        );
                  },
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey[300],
                    child:
                        tutor.profilePhotoUrl != null &&
                                tutor.profilePhotoUrl!.isNotEmpty
                            ? ClipOval(
                              child: Image.network(
                                tutor.profilePhotoUrl!,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stack) {
                                  debugPrint("Image load error: $error");
                                  return const Icon(
                                    Icons.person,
                                    size: 32,
                                    color: Colors.white,
                                  );
                                },
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 32,
                              color: Colors.white,
                            ),
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
