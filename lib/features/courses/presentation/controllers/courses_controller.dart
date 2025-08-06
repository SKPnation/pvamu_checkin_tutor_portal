import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CoursesController extends GetxController{
  static CoursesController get instance => Get.find();

  final courseNameTEC = TextEditingController();
  final courseCodeTEC = TextEditingController();
  final courseCategoryTEC = TextEditingController();

  var courseStatus = "archived".obs;
}