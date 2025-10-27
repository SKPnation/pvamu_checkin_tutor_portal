import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/tutor_item.dart';

class TutorsTable extends StatefulWidget {
  const TutorsTable({super.key});

  @override
  State<TutorsTable> createState() => _TutorsTableState();
}

class _TutorsTableState extends State<TutorsTable> {
  final tutorsController = TutorsController.instance;
  final courseController = CoursesController.instance;

  var columnsArray = [
    "First Name",
    "Last Name",
    "Email",
    "Time In",
    "Time Out",
    "Duration",
    'Status',
    "Date Added",
    "Actions",
  ];

  @override
  void initState() {
    tutorsController.getTutors();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1,
          color: AppColors.grey[300]!.withOpacity(.3),
        ),
      ),

      child: Column(
        children: [
          SizedBox(height: 4),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(), // First name column
              1: FlexColumnWidth(), // Last name column
              2: FlexColumnWidth(), // Email column
              3: FlexColumnWidth(), // Time In column//
              4: FlexColumnWidth(), // Time In column//
              5: FlexColumnWidth(), // Duration column//
              6: FlexColumnWidth(), // Status column//
              7: FlexColumnWidth(), // Date Added column//
              8: FlexColumnWidth(), // Actions column// // Status column
            },
            children: [
              TableRow(
                children:
                    columnsArray
                        .map(
                          (e) => Center(
                            child: CustomText(
                              text: e.toUpperCase(),
                              size: 12,
                              weight: FontWeight.bold,
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
          SizedBox(height: 4),
          const Divider(),

          Obx(() {
            if (tutorsController.isLoading.value) {
              return const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (tutorsController.error.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${tutorsController.error.value}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (tutorsController.tutors.isEmpty) {
              return const Center(child: Text("No tutors found"));
            }

            return Column(
              children: tutorsController.tutors.map((e) {
                var isLastItem =
                    tutorsController.tutors.last.id == e.id;
                return TutorItem(
                  item: e,
                  isLastItem: isLastItem,
                  coursesController: courseController,
                  tutorsController: tutorsController,
                );
              }).toList(),
            );
          }),

        ],
      ),
    );
  }
}
