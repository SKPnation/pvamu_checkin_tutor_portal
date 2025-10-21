import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/controllers/courses_controller.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/presentation/widgets/course_item.dart';

class AssignCourseField extends StatefulWidget {
  const AssignCourseField({
    super.key,
    required this.coursesController,
    this.onChanged,
  });

  final CoursesController coursesController;
  final VoidCallback? onChanged;

  @override
  State<AssignCourseField> createState() => _AssignCourseFieldState();
}

class _AssignCourseFieldState extends State<AssignCourseField> {
  CoursesController get cc => widget.coursesController; // <-- use the injected one

  @override
  void initState() {
    super.initState();
    cc.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() {
        if (cc.isLoading.value) {
          return const Center(
            child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
          );
        }

        if (cc.error.isNotEmpty) {
          return Center(
            child: Text('Error: ${cc.error.value}',
                style: const TextStyle(color: Colors.red)),
          );
        }

        if (cc.courses.isEmpty) {
          return const Center(child: Text('No courses found'));
        }

        // 1) Define groups (order matters)
        const groupOrder = ['CVEG', 'MATH', 'CHEM', 'ELEG', 'MCEG', 'PHYS'];
        final grouped = <String, List<Course>>{
          for (final g in groupOrder) g: <Course>[],
        };

        // 2) Put courses into groups (others go to OTHER)
        grouped['OTHER'] = <Course>[];
        for (final c in cc.courses) {
          final pref = groupOrder.firstWhere(
                (p) => (c.code ?? '').startsWith(p),
            orElse: () => 'OTHER',
          );
          grouped[pref]!.add(c);
        }

        // 3) Sort each group numerically by course code digits
        for (final g in grouped.values) {
          g.sort((a, b) {
            final aNum = int.tryParse(a.code?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ?? 0;
            final bNum = int.tryParse(b.code?.replaceAll(RegExp(r'[^0-9]'), '') ?? '') ?? 0;
            return aNum.compareTo(bNum);
          });
        }

        // 4) Build a FLAT list of dropdown items:
        //    - header items: enabled:false, value:null
        //    - course items: enabled:true, value: course.id
        final List<DropdownMenuItem<String?>> items = [];
        final Map<String, Course> byId = {};

        for (final prefix in [...groupOrder, 'OTHER']) {
          final list = grouped[prefix]!;
          if (list.isEmpty) continue;

          // Header (disabled)
          items.add(
            DropdownMenuItem<String?>(
              enabled: false,
              value: null, // requires DropdownButtonFormField<String?>
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                color: AppColors.grey[200],
                child: Text(
                  '$prefix Courses',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          );

          // Items (selectable)
          for (final c in list) {
            byId[c.id!] = c;
            items.add(
              DropdownMenuItem<String?>(
                value: c.id!,
                child: _CourseRow(course: c), // simple row; replace with your CourseItem if you like
              ),
            );
          }

          // Optional visual divider (disabled item)
          // items.add(
          //   const DropdownMenuItem<String?>(
          //     enabled: false,
          //     value: null,
          //     child: Divider(height: 10),
          //   ),
          // );
        }

        final selectedId = cc.selectedCourse?.value.id;

        return DropdownButtonFormField<String?>(
          isExpanded: true,
          value: selectedId, // null when nothing selected
          items: items,
          decoration: const InputDecoration(
            labelText: 'Select course',
            border: OutlineInputBorder(),
          ),
          // Prevent selecting headers/dividers (their value is null)
          onChanged: (id) {
            if (id == null) return;
            final course = cc.courses.firstWhere((c) => c.id == id);
            if (cc.selectedCourse == null) {
              cc.selectedCourse = Rx<Course>(course);
            } else {
              cc.selectedCourse!.value = course;
            }
            widget.onChanged?.call();
            setState(() {});
          },

          // Optional: show only the selected course text when the field is closed
          selectedItemBuilder: (context) {
            return items.map((item) {
              final id = item.value;
              if (id == null) {
                // for headers/dividers, return an empty box so they don't appear in the closed field
                return const SizedBox.shrink();
              }
              final c = byId[id]!;
              return Align(
                alignment: Alignment.centerLeft,
                child: Text('${c.code} — ${c.name}', overflow: TextOverflow.ellipsis),
              );
            }).toList();
          },
        );
      }),
    );
  }
}

/// Simple course row used in the dropdown list.
/// (If you already have a CourseItem widget, you can reuse it here.)
class _CourseRow extends StatelessWidget {
  const _CourseRow({required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${course.code} — ${course.name}',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
