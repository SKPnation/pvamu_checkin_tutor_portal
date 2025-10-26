import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/fonts.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
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
  var sortedEntries = <MapEntry<String, dynamic>>[];

  final List<String> weekdayOrder = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: CustomText(text: "Profile"),
          content: FutureBuilder(
            future: widget.tutorsController.getProfile(tutorId: widget.tutorId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Color(0xFF43A95D)),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }

              Tutor tutor = snapshot.data!;

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
              final List<MapEntry<String, dynamic>> entries =
                  schedule.entries.toList()..sort((a, b) {
                    final ak = (a.key).toString().toLowerCase();
                    final bk = (b.key).toString().toLowerCase();

                    // -1 means "not found" -> push to bottom by using a large index
                    int ai = weekdayOrder.indexOf(ak);
                    int bi = weekdayOrder.indexOf(bk);
                    if (ai == -1) ai = 999;
                    if (bi == -1) bi = 999;

                    return ai.compareTo(bi);
                  });
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.person,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(width: 8),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: tutor.name!, size: AppFonts.baseSize,),
                          SizedBox(height: 2),
                          CustomText(text: tutor.email!),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  CustomText(text: "Work schedule", size: AppFonts.baseSize+4),

                  SizedBox(height: 8),

                  //Work schedule section
                  WorkScheduleSection(
                    sortedEntries: entries,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
