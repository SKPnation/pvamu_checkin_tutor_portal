import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/repos/courses_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

class CoursesController extends GetxController {
  static CoursesController get instance => Get.find();

  final courseNameTEC = TextEditingController();
  final courseCodeTEC = TextEditingController();

  var courseStatus = "archived".obs;

  CoursesRepoImpl coursesRepo = CoursesRepoImpl();

  Rx<Course>? selectedCourse;
  Rx<Tutor>? selectedTutor;

  var courses = <Course>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  Future addCourse() async {
    await coursesRepo.add(
        Course(
          id: coursesRepo.coursesCollection.doc().id,
          name: courseNameTEC.text,
          code: courseCodeTEC.text,
          status: "Published",
          createdAt: DateTime.now(),
        ));

    courseNameTEC.clear();
    courseCodeTEC.clear();

    getCourses();
  }

  Future<List<Course>> getCourses() async =>
    courses.value = await coursesRepo.getCourses();


  Future archiveCourse({required String courseId}) async{
    await coursesRepo.archive(courseId: courseId);
    getCourses();
  }

  Future delete({required String courseId}) async {
    await coursesRepo.delete(courseId: courseId);
    getCourses();
  }
}
