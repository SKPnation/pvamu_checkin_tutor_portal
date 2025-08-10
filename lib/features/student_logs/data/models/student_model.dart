import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/repos/courses_repo_impl.dart';

class Student {
  final String? id;
  final String? name;
  final String? email;
  final Course? course;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;

  Student({
    this.id,
    this.name,
    this.email,
    this.course,
    this.createdAt,
    this.timeIn,
    this.timeOut,
  });

  static Future<Student> fromMapAsync(Map<String, dynamic> map, String docId) async {
    Course course = await getCourse(map['course'] as DocumentReference);

    return Student(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
      timeIn: map['time_in'] != null ? (map['time_in'] as Timestamp).toDate() : null,
      timeOut: map['time_out'] != null ? (map['time_out'] as Timestamp).toDate() : null,
      course: course,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': Timestamp.fromDate(createdAt!),
      'time_in': timeIn != null ? Timestamp.fromDate(timeIn!) : null,
      'time_out': timeOut != null ? Timestamp.fromDate(timeOut!) : null,
      'course': CoursesRepoImpl().coursesCollection.doc(course?.id!),
    };
  }
}

Future<Course> getCourse(DocumentReference docRef) async {
  final courseSnap = await docRef.get();
  return Course.fromMap(
    courseSnap.data() as Map<String, dynamic>,
  );
}