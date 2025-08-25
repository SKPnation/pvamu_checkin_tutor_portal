import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/presentation/widgets/settings_horizontal_menu_item.dart';

class SettingsSideMenuItem extends StatelessWidget {
  final String? itemName;
  final Function()? onTap;
  const SettingsSideMenuItem({
    super.key,
    this.itemName,
    this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsHorizontalMenuItem(itemName: itemName!, onTap: onTap!),
        SizedBox(height: 20)
      ],
    );
  }
}
