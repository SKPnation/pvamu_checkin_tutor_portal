import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/domain/repos/courses_repo.dart';

class CoursesRepoImpl extends CoursesRepo {
  final CollectionReference coursesCollection = FirebaseFirestore.instance
      .collection('courses');
  final CollectionReference assignedCollection = FirebaseFirestore.instance
      .collection('assigned');
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');
  @override
  Future<void> add(Course course) async {
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

  @override
  Future<void> archive({required String courseId}) async{
    await coursesCollection.doc(courseId).update({"status": "Archived"});
  }

  @override
  Future<void> delete({required String courseId}) async{
    final courseRef = coursesCollection.doc(courseId);

    // 1. Find all "assigned" docs where 'courses' array contains this courseRef
    final assignedQuery = await assignedCollection
        .where('courses', arrayContains: courseRef)
        .get();

    // 2. Loop through each and remove the reference from the array
    for (final doc in assignedQuery.docs) {
      await doc.reference.update({
        'courses': FieldValue.arrayRemove([courseRef]),
      });
    }

    // 3. Find all "students" docs where 'course' == courseRef
    final studentsQuery = await studentsCollection
        .where('course', isEqualTo: courseRef)
        .get();

    // 4. Loop through each and update "course" field with null
    for (final doc in studentsQuery.docs) {
      await doc.reference.update({
        'course': null,
      });
    }

    // 5. Delete the course document
    await courseRef.delete();

    CustomSnackBar.successSnackBar(body: "Deleted successfully");
  }


}
