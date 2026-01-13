import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_button.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class EditScheduleSection extends StatefulWidget {
  const EditScheduleSection({super.key, required this.tutorId});

  final String tutorId;

  @override
  State<EditScheduleSection> createState() => _EditScheduleSectionState();
}

class _EditScheduleSectionState extends State<EditScheduleSection> {
  final tutorController = TutorsController.instance;

  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => startTime = picked);
  }

  Future<void> pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => endTime = picked);
  }

  void setAvailability(String tutorId) async{
    if (selectedDay != null && startTime != null && endTime != null) {
      await tutorController.setSchedule(selectedDay!, startTime!, endTime!, tutorId);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButton<String>(
          dropdownColor: AppColors.white,
          hint: const Text("Select Day"),
          value: selectedDay,
          items:
          ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
              .map(
                (day) =>
                DropdownMenuItem(value: day, child: Text(day)),
          )
              .toList(),
          onChanged: (value) => setState(() => selectedDay = value),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: 200,
          child: CustomButton(
            bgColor: AppColors.white,
            showBorder: false,
            onPressed: () => pickStartTime(context),
            child: CustomText(
              text:
              startTime == null
                  ? "Pick Start Time"
                  : "Start: ${startTime!.format(context)}",
              color: AppColors.purple,
            ),
          ),
        ),
        SizedBox(height: 4),
        SizedBox(
          width: 200,
          child: CustomButton(
            bgColor: AppColors.white,
            showBorder: false,
            onPressed: () => pickEndTime(context),
            child: CustomText(
              text:
              endTime == null
                  ? "Pick End Time"
                  : "End: ${endTime!.format(context)}",
              color: AppColors.purple,
            ),
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: 200,
          child: CustomButton(
            bgColor: AppColors.gold,
            onPressed: (){
              setAvailability(widget.tutorId);

              setState(() {});
            },
            child: CustomText(text: "Set", color: AppColors.white),
          ),
        ),
      ],
    );
  }
}
