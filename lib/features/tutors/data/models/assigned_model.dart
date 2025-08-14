import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

class AssignedModel {
  final String? id;
  final List<Course>? courses;
  final Tutor? tutor;
  final DateTime? createdAt;

  AssignedModel({
    required this.id,
    required this.courses,
    required this.tutor,
    this.createdAt,
  });

  static Future<AssignedModel> fromMapAsync(Map<String, dynamic> map) async {
    List<dynamic> coursesRefs = map['courses'] ?? [];
    List<Course>? courses;
    if (coursesRefs.isNotEmpty) {
      courses = await getAssignedCourses(coursesRefs);
    }

    return AssignedModel(
      id: map['id'],
      courses: courses,
      tutor: null,
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
    );
  }
}
