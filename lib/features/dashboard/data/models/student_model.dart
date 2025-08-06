import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String? id;
  final String? name;
  final String? email;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;

  Student({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.timeIn,
    this.timeOut,
  });

  factory Student.fromMap(Map<String, dynamic> map, String documentId) {
    return Student(
      id: documentId,
      name: map['name'],
      email: map['email'],
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
      timeIn: (map['time_in'] as Timestamp?)?.toDate(),
      timeOut: (map['time_out'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'time_in': timeIn != null ? Timestamp.fromDate(timeIn!) : null,
      'time_out': timeOut != null ? Timestamp.fromDate(timeOut!) : null,
    };
  }
}
