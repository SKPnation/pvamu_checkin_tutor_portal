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
        return _customIcon(Icons.home, itemName);
      case Routes.coursesDisplayName:
        return _customIcon(Icons.book, itemName);
      default:
        return _customIcon(Icons.logout, itemName);
    }
  }

  String returnRouteName(){
    switch(activePageRoute.value){
      case Routes.dashboardRoute:
        return Routes.dashboardDisplayName;
      case Routes.coursesRoute:
        return Routes.coursesDisplayName;
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