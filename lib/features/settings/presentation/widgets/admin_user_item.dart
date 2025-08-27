import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_text.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/presentation/controllers/settings_controller.dart';

class AdminUserItem extends StatelessWidget {
  AdminUserItem({
    super.key,
    required this.item,
    required this.isLastItem,
    required this.settingsController,
  });

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
            2: FlexColumnWidth(), // Actions column
            // Actions column//
          },

          children: [
            TableRow(
              children: [
                Center(
                  child: CustomText(
                    text: "${item.firstName} ${item.lastName}",
                    size: 12,
                  ),
                ),
                Center(
                  child: CustomText(text: item.email.toString(), size: 12),
                ),

                Center(
                  child: GestureDetector(
                    key: actionKey, // Assign the key here
                    onTap:
                        () => displayActionPopUp(
                          context,
                          SettingsController.instance,
                          actionKey,
                          item.id,
                        ),
                    child: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
          ],
        ),

        if (!isLastItem) Divider(),
        if (isLastItem) SizedBox(height: 8),
      ],
    );
  }

  displayActionPopUp(
    BuildContext context,
    SettingsController settingsController,
    GlobalKey key,
    String adminUserId,
  ) {
    // Get the RenderBox and its position
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Show the menu at the calculated position
    return showMenu(
      color: Colors.white, // Set your preferred color
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx, // X-coordinate of the GestureDetector
        offset.dy + size.height, // Y-coordinate + height of the item
        offset.dx + size.width, // Width of the GestureDetector
        0, // No margin at the bottom
      ),
      items: [
        PopupMenuItem(
          onTap: () async {
            await settingsController.blockAdmin(adminUserId);
          },
          value: 'block',
          child: const Text('Block'),
        ),
        PopupMenuItem(
          onTap: () async {
            await settingsController.deleteAdmin(adminUserId);
          },
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
    );
  }
}
