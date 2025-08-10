import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor {
  final String? id;
  final String? name;
  final String? email;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;

  Tutor({
    this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.timeIn,
    this.timeOut,
  });

  factory Tutor.fromMap(Map<String, dynamic> map) {
    return Tutor(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
      timeIn: (map['time_in'] as Timestamp?)?.toDate(),
      timeOut: (map['time_out'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'created_at': Timestamp.fromDate(createdAt!),
      'time_in': null,
      'time_out': null,
    };
  }
}
