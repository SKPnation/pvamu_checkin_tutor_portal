import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/core/utils/functions.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/models/course_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/courses/data/repos/courses_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/student_logs/data/repos/student_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/tutors/data/models/tutor_model.dart';

class Student {
  final String? id;
  final String? name;
  final String? email;
  final Course? course;
  final Tutor? tutor;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;

  Student({
    this.id,
    this.name,
    this.email,
    this.course,
    this.tutor,
    this.createdAt,
    this.timeIn,
    this.timeOut,
  });

  static Future<Student> fromMapAsync(Map<String, dynamic> map, String docId) async {
    Course course = await getCourse(map['course'] as DocumentReference);
    Tutor? tutor;
    if(map['tutor'] != null){
     tutor = await getTutor(map['tutor'] as DocumentReference);
    }

    return Student(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
      timeIn: map['time_in'] != null ? (map['time_in'] as Timestamp).toDate() : null,
      timeOut: map['time_out'] != null ? (map['time_out'] as Timestamp).toDate() : null,
      course: course,
      tutor: tutor
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
      'tutor': StudentRepoImpl().studentsCollection.doc(tutor?.id!)
    };
  }
}