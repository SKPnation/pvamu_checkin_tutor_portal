import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/widgets/course_item.dart';

class CoursesTable extends StatefulWidget {
  const CoursesTable({super.key});

  @override
  State<CoursesTable> createState() => _CoursesTableState();
}

class _CoursesTableState extends State<CoursesTable> {
  final coursesController = CoursesController.instance;
  var columnsArray = ["Code", "Name", "Status", "Action"];

  @override
  void initState() {
    coursesController.getCourses();

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
              0: FlexColumnWidth(), // Course column
              1: FlexColumnWidth(), // Code column
              2: FlexColumnWidth(), // Category column
              3: FlexColumnWidth(), // Status column
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
            if (coursesController.isLoading.value) {
              return const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (coursesController.error.isNotEmpty) {
              return Center(
                child: Text(
                  'Error: ${coursesController.error.value}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (coursesController.courses.isEmpty) {
              return const Center(child: Text("No courses found"));
            }

            // Define group order
            final groupOrder = ["CVEG", "MATH", "CHEM", "ELEG", "MCEG", "PHYS"];

            // Group courses by prefix
            final groupedCourses = <String, List<Course>>{};
            for (var course in coursesController.courses) {
              final prefix = groupOrder.firstWhere(
                    (p) => course.code!.startsWith(p),
                orElse: () => "OTHER",
              );
              groupedCourses.putIfAbsent(prefix, () => []).add(course);
            }

            // Render groups in defined order
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupOrder.map((prefix) {
                final courses = groupedCourses[prefix] ?? [];
                if (courses.isEmpty) return SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Header
                    Container(
                      width: double.infinity,
                      color: AppColors.grey[200],
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                      child: Text(
                        "$prefix Courses",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Group Items
                    ...courses.map((e) {
                      var isLastItem = courses.last.id == e.id;
                      return CourseItem(item: e, isLastItem: isLastItem);
                    }),
                    const Divider(),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}
