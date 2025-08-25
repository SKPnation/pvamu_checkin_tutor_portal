import 'package:flutter/material.dart';
import 'package:pvamu_checkin_tutor_portal/core/constants/app_strings.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/responsiveness.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/helpers/size_helpers.dart';
import 'package:pvamu_checkin_tutor_portal/features/site_layout/presentation/widgets/horizontal_menu_item.dart';

class SideMenuItem extends StatelessWidget {
  final String? itemName;
  final Function()? onTap;

  const SideMenuItem({super.key, this.itemName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        itemName == AppStrings.logoutTitle
            ? SizedBox(height: displayHeight(context) / 3)
            : const SizedBox(),
        HorizontalMenuItem(itemName: itemName!, onTap: onTap!),
      ],
    );
    // if(ResponsiveWidget.isCustomScreen(context)){
    //   return VerticalMenuItem(itemName: itemName!, onTap: onTap!);
    // }else{
    //   return Column(
    //     children: [
    //       itemName == AppStrings.logOutTitle ? SizedBox(height: displayHeight(context)/2) : const SizedBox(),
    //       HorizontalMenuItem(itemName: itemName!, onTap: onTap!)
    //     ],
    //   );
    // }
  }
}
