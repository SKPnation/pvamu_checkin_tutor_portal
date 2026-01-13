import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/data/local/get_store.dart';
import 'package:pvamu_checkin_tutor_portal/core/navigation/app_routes.dart';
import 'package:pvamu_checkin_tutor_portal/core/theme/colors.dart';

class MenController extends GetxController{
  static MenController get instance => Get.find();
  // var activeItem = Routes.dashboardDisplayName.obs;
  var activePageRoute = getStore.get("activePageRoute").toString().obs;
  var hoverItem = "".obs;

  changeActiveItemTo(String itemName, String route) {
    // activeItem.value = itemName;
    activePageRoute.value = route;
    getStore.set("activePageRoute", route);
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  isHovering(String itemName) => hoverItem.value == itemName;

  isActive(String itemName) => returnRouteName() == itemName;

  Widget returnIconFor(String itemName){
    switch(itemName){
      case Routes.dashboardDisplayName:
        return _customIcon(Icons.dashboard, itemName);
      case Routes.studentsDisplayName:
        return _customIcon(Icons.people, itemName);
      case Routes.coursesDisplayName:
        return _customIcon(Icons.book, itemName);
      case Routes.tutorsDisplayName:
        return _customIcon(Icons.people, itemName);
      case Routes.assignedTutorsDisplayName:
        return _customIcon(Icons.person_pin_rounded, itemName);
      case Routes.settingsDisplayName:
        return _customIcon(Icons.settings, itemName);
      case Routes.logoutDisplayName:
        return _customIcon(Icons.logout, itemName);
      default:
        return _customIcon(Icons.logout, itemName);
    }
  }

  String returnRouteName(){
    switch(activePageRoute.value){
      case Routes.dashboardRoute:
        return Routes.dashboardDisplayName;
      case Routes.studentsRoute:
        return Routes.studentsDisplayName;
      case Routes.coursesRoute:
        return Routes.coursesDisplayName;
      case Routes.tutorsRoute:
        return Routes.tutorsDisplayName;
      case Routes.assignedTutorsRoute:
        return Routes.assignedTutorsDisplayName;
      case Routes.settingsRoute:
        return Routes.settingsDisplayName;
      case Routes.authRoute:
        return Routes.logoutDisplayName;
      default:
        return Routes.dashboardDisplayName;
    }
  }

  Widget _customIcon(IconData icon, String itemName){
    if(itemName == returnRouteName()) return Icon(icon, size: 22, color: AppColors.gold);

    return Icon(icon, color: isHovering(itemName)
        ? AppColors.gold
        : AppColors.grey[900]);
  }

}