import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/data/models/student_model.dart';

class StudentLogItem extends StatelessWidget {
  const StudentLogItem({
    super.key,
    required this.item,
    required this.isLastItem,
  });

  final Student item;
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
            3: FlexColumnWidth(), // Tutor column
            4: FlexColumnWidth(), // Time In column
            5: FlexColumnWidth(), // Time Out column
            6: FlexColumnWidth(), // Duration column
            7: FlexColumnWidth(), // Status column
          },
          children: [
            TableRow(
              children: [
                Center(child: CustomText(text: item.name.toString(), size: 12)),
                Center(
                  child: CustomText(text: item.email.toString(), size: 12),
                ),
                Center(
                  child: SizedBox(width: 100, child: CustomText(
                    text: "${item.course?.category!} - ${item.course?.name!}",
                    size: 12,
                  ))
                ),
                Center(
                    child: SizedBox(width: 100, child: CustomText(
                      text: "${item.tutor == null ? "tutor" : item.tutor?.name!}",
                      size: 12,
                    ))
                ),
                Center(
                  child: CustomText(text: formatTime(item.timeIn), size: 12),
                ),
                Center(
                  child: CustomText(
                    text:
                        item.timeOut == null ? "--" : formatTime(item.timeOut),
                    size: 12,
                  ),
                ),

                //duRATION
                Center(
                  child: CustomText(
                    text:
                        item.timeOut == null
                            ? "--"
                            : formatDuration(
                              item.timeOut!.difference(item.timeIn!),
                            ),
                    size: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: item.timeOut == null ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    SizedBox(width: 4),
                    CustomText(
                      text: item.timeOut == null ? "Signed In" : "Signed Out",
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        if (!isLastItem) Divider(),
      ],
    );
  }
}
