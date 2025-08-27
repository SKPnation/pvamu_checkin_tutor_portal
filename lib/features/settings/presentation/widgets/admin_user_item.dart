import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

class AdminUserItem extends StatelessWidget {
  AdminUserItem({super.key, required this.item, required this.isLastItem, required this.settingsController});

  final AdminUser item;
  final bool isLastItem;

  final GlobalKey actionKey = GlobalKey();

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Column(
     children: [
       Table(
         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
         columnWidths: const {
           0: FlexColumnWidth(), // Name column
           1: FlexColumnWidth(), // Email column
         // Actions column//
         },

         children: [
           TableRow(
             children: [
               Center(child: CustomText(text: "${item.firstName} ${item.lastName}", size: 12)),
               Center(
                 child: CustomText(text: item.email.toString(), size: 12),
               ),
             ]
           )
         ],
       ),
     ],
    );
  }
}
