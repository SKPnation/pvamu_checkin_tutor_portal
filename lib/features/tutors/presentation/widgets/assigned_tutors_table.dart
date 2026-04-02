import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/assigned_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/controllers/tutors_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/assigned_tutor_item.dart';

class AssignedTutorsTable extends StatefulWidget {
  const AssignedTutorsTable({super.key});

  @override
  State<AssignedTutorsTable> createState() => _AssignedTutorsTableState();
}

class _AssignedTutorsTableState extends State<AssignedTutorsTable> {
  final tutorsController = TutorsController.instance;

  var columnsArray = ["Assigned Tutor", "Schedule", "Course(s)", "Actions"];

  @override
  void initState() {
    tutorsController.fetchAssignedTutors();
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
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1.2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(1),// Status column//
            },
            children: [
              TableRow(
                children: columnsArray
                    .map(
                      (e) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: e.toUpperCase(),
                        size: 12,
                        weight: FontWeight.bold,
                      ),
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
            if (tutorsController.isAssignedLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (tutorsController.assignedError.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${tutorsController.assignedError.value}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            if (tutorsController.assignedTutors.isEmpty) {
              return const Center(child: Text('No assignments found'));
            }

            return Column(
              children:
                  tutorsController.assignedTutors.map((e) {
                    var isLastItem =
                        tutorsController
                            .assignedTutors[tutorsController
                                    .assignedTutors
                                    .length -
                                1]
                            .id ==
                        e.id;

                    return AssignedTutorItem(
                      item: e,
                      isLastItem: isLastItem,
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
