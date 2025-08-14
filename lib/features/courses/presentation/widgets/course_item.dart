import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({super.key, required this.item, required this.isLastItem});

  final Course item;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(), // Name column
            1: FlexColumnWidth(), // Email column
            2: FlexColumnWidth(), // Course column
            3: FlexColumnWidth(), // Time In column// Status column
          },
          children: [
            TableRow(
              children: [
                Center(child: CustomText(text: item.name.toString(), size: 12)),
                Center(
                  child: CustomText(text: item.code.toString(), size: 12),
                ),
                Center(child: CustomText(text: item.category.toString(), size: 12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          color: item.status!.toLowerCase() == "published" ? Colors.green : AppColors.grey,
                          borderRadius: BorderRadius.circular(100)
                      ),
                    ),
                    SizedBox(width: 4),
                    CustomText(
                      text: item.status,
                      size: 12,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),

        if (!isLastItem) Divider(),
        if(isLastItem) SizedBox(height: 8),
      ],
    );
  }
}
