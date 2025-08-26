import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/settings_routes.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  final firstNameTEC = TextEditingController();
  final lastNameTEC = TextEditingController();
  final emailAddressTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  Future addAdminUser() async {
    //..
  }

  var activeItem = SettingsRoutes.generalDisplayName.obs;
  final GlobalKey<NavigatorState> settingsNavigatorKey = GlobalKey();

  var hoverItem = "".obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => activeItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case SettingsRoutes.generalDisplayName:
        return _customIcon(Icons.public, itemName);
      case SettingsRoutes.securityDisplayName:
        return _customIcon(Icons.security, itemName);
      case SettingsRoutes.teamManagementDisplayName:
        return _customIcon(Icons.people, itemName);
      default:
        return _customIcon(Icons.public, itemName);
    }
  }

  Widget _customIcon(IconData icon, String itemName) {
    if (itemName == activeItem.value) {
      return Icon(icon, size: 22, color: AppColors.gold);
    }

    return Icon(
      icon,
      color: isHovering(itemName) ? AppColors.gold : AppColors.grey[900],
    );
  }

  Future<dynamic> navigateTo(String routeName) {
    return settingsNavigatorKey.currentState!.pushNamed(routeName);
  }

  goBack() => settingsNavigatorKey.currentState!.pop();

  Future getAdminUsers() async{}
}
