import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/fonts.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class WorkScheduleSection extends StatelessWidget {
  const WorkScheduleSection({super.key, required this.sortedEntries, required this.tutorController });

  final List<MapEntry<String, dynamic>> sortedEntries;
  final TutorsController tutorController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          sortedEntries.map((e) {
            var heading = e.key;
            var body = e.value;

            return Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Text(
                    "${heading[0].toUpperCase()}${heading.substring(1)}: ",
                    // Capitalize
                    style: const TextStyle(fontSize: AppFonts.defaultSize),
                  ),
                  Text(
                    body.toString(),
                    style: const TextStyle(fontSize: AppFonts.defaultSize),
                  ),
                  IconButton(onPressed: (){
                    tutorController.deleteSlot(tutorId: tutorController.selectedTutor.value?.id, slot: e);
                  }, icon: const Icon(
                    Icons.delete,
                    size: 15,
                    color: AppColors.red,
                  ),)
                ],
              ),
            );
          }).toList(),
    );
  }
}
