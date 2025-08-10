import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/domain/repos/courses_repo.dart';

class CoursesRepoImpl extends CoursesRepo {
  final CollectionReference coursesCollection = FirebaseFirestore.instance
      .collection('courses');

  @override
  Future<void> addCourse(Course course) async {
    try {
      final data = Map<String, dynamic>.from(course.toMap());

      await coursesCollection
          .doc(course.toMap()['id'])
          .set(data);

      Get.back();

      CustomSnackBar.successSnackBar(body: "Added new course");
    } catch (e) {
      CustomSnackBar.errorSnackBar("Failed: $e");
      // Handle failure here
    }
  }

  @override
  Future<List<Course>> getCourses() async{
    final querySnapshot = await coursesCollection.get();
    List<Course> courses =
    querySnapshot.docs.map((doc) {
      return Course.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return courses;
  }
}
