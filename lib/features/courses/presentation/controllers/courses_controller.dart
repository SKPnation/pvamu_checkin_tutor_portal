import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/repos/courses_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

class CoursesController extends GetxController {
  static CoursesController get instance => Get.find();

  final courseNameTEC = TextEditingController();
  final courseCodeTEC = TextEditingController();
  final courseCategoryTEC = TextEditingController();

  var courseStatus = "archived".obs;

  CoursesRepoImpl coursesRepo = CoursesRepoImpl();

  Rx<Course>? selectedCourse;
  Rx<Tutor>? selectedTutor;

  Future addCourse() async => await coursesRepo.addCourse(
    Course(
      id: coursesRepo.coursesCollection.doc().id,
      name: courseNameTEC.text,
      code: courseCodeTEC.text,
      category: courseCategoryTEC.text,
      status: "Published",
      createdAt: DateTime.now(),
    ),
  );

  Future<List<Course>> getCourses() async =>
      await coursesRepo.getCourses();
}
