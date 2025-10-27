import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';

class AssignTutorField extends StatefulWidget {
  const AssignTutorField({super.key, required this.tutorsController, this.onChanged});

  final TutorsController tutorsController;
  final Function()? onChanged;

  @override
  State<AssignTutorField> createState() => _AssignTutorFieldState();
}

class _AssignTutorFieldState extends State<AssignTutorField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FutureBuilder(
        future: widget.tutorsController.getTutors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Color(0xFF43A95D),
                ),
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

          var tutors = snapshot.data as List<Tutor>;

          var selectedTutor = widget.tutorsController.selectedTutor?.value;
          String? selectedTutorId;

          if (selectedTutor != null &&
              selectedTutor.fName != null &&
              selectedTutor.fName!.isNotEmpty) {
            // Find course by name in the fetched list
            try {
              selectedTutorId =
                  tutors
                      .firstWhere((c) => c.fName == selectedTutor.fName)
                      .id;
            } catch (e) {
              // If no course matches, leave selectedCourseId null
              selectedTutorId = null;
            }
          } else {
            selectedTutorId = null;
          }

          return DropdownButtonFormField<String>(
            value: selectedTutorId,
            items:
            tutors.map((tutor) {
              return DropdownMenuItem<String>(
                value: tutor.id,
                child: Text("${tutor.fName} ${tutor.lName}"),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                if (value != null) {
                  final tutor = tutors.firstWhere(
                        (tutor) => tutor.id == value,
                  );
                  if (widget.tutorsController.selectedTutor == null) {
                    widget.tutorsController.selectedTutor = Rx<Tutor>(
                      tutor,
                    );
                  } else {
                    widget.tutorsController.selectedTutor!.value = tutor;
                  }
                }
              });

              widget.onChanged!();
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Select tutor',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
    );
  }
}
