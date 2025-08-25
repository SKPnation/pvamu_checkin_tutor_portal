import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';

abstract class CoursesRepo {
  Future<void> add(Course course);
  Future<void> archive({required String courseId});
  Future<void> delete({required String courseId});
  Future<List<Course>> getCourses(); //for new user

}