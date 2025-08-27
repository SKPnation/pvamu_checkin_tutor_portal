import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final int? level;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final DateTime? blockedAt;

  AdminUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.level,
    this.timeIn,
    this.timeOut,
    this.createdAt,
    this.updatedAt,
    this.blockedAt,
  });

  factory AdminUser.fromMap(Map<String, dynamic> map) {
    return AdminUser(
      id: map['id'],
      firstName: map['f_name'],
      lastName: map['l_name'],
      email: map['email'],
      password: map['password'],
      level: map['level'],
      timeIn: (map['time_in'] as Timestamp?)?.toDate(),
      timeOut: (map['time_out'] as Timestamp?)?.toDate(),
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
      updatedAt: (map['updated_at'] as Timestamp?)?.toDate(),
      blockedAt: (map['blocked_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'f_name': firstName,
      'l_name': lastName,
      'email': email,
      'password': password,
      'level': level,
      'created_at': Timestamp.fromDate(createdAt!),
      'updated_at': Timestamp.fromDate(updatedAt!),
      'blocked_at':  Timestamp.fromDate(blockedAt!),
      'time_in': Timestamp.fromDate(timeIn!),
      'time_out': Timestamp.fromDate(timeOut!),
    };
  }
}
