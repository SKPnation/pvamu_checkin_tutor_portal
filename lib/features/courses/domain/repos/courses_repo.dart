import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';

abstract class CoursesRepo {
  Future<void> addCourse(Course course);
  Future<List<Course>> getCourses(); //for new user

}