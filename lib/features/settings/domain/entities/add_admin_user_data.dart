import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pvamu_checkin_tutor_portal/core/domain/query_params.dart';

class AddAdminUserData extends QueryParams {
  String id = '';
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? timeIn;
  DateTime? timeOut;
  DateTime? blockedAt;

  AddAdminUserData({
    required this.id,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.createdAt,
    this.updatedAt,
    this.timeIn,
    this.timeOut,
    this.blockedAt,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'f_name': firstName,
    'l_name': lastName,
    'time_in': null,
    'time_out': null,
    'created_at': DateTime.now(),
    'updated_at': DateTime.now(),
    'blocked_at': null,
  };
}
