import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/fonts.dart';

class WorkScheduleSection extends StatelessWidget {
  const WorkScheduleSection({super.key, required this.sortedEntries});

  final List<MapEntry<String, dynamic>> sortedEntries;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: sortedEntries.map((e){

        var heading = e.key;
        var body = e.value;

        return Padding(padding: EdgeInsets.only(bottom: 2), child: Row(
          children: [
            Text(
              "${heading[0].toUpperCase()}${heading.substring(1)}: ",
              // Capitalize
              style: const TextStyle(
                fontSize: AppFonts.defaultSize,
              ),
            ),
            Text(
              body.toString(),
              style: const TextStyle(
                fontSize: AppFonts.defaultSize,
              ),
            ),
          ],
        ));
      }).toList(),
    );
  }
}
