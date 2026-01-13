import 'package:get/get.dart';

class DashboardController extends GetxController{
  static DashboardController get instance => Get.find();

  var viewIndex = 0.obs;

  final views = [
    "Student Logs",
    "Tutor Logs"
  ];

  setIndex(int index){
    viewIndex.value = index;
  }
}