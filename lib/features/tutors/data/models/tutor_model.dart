import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor {
  final String? id;
  final String? fName;
  final String? lName;
  final String? email;
  final Map<String, dynamic>? workSchedule;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final DateTime? blockedAt;

  Tutor({
    this.id,
    required this.fName,
    required this.lName,
    required this.email,
    this.workSchedule,
    required this.createdAt,
    this.blockedAt,
    this.timeIn,
    this.timeOut,
  });

  factory Tutor.fromMap(Map<String, dynamic> map) {
    return Tutor(
      id: map['id'],
      fName: map['f_name'],
      lName: map['l_name'],
      email: map['email'],
      workSchedule: map['work_schedule'],
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
      blockedAt: (map['blocked_at'] as Timestamp?)?.toDate(),
      timeIn: (map['time_in'] as Timestamp?)?.toDate(),
      timeOut: (map['time_out'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'created_at': Timestamp.fromDate(createdAt!),
      'blocked_at': null,
      'time_in': null,
      'time_out': null,
    };
  }
}
