import 'package:pvamu_checkin_tutor_portal/core/domain/query_params.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/domain/entities/add_admin_user_data.dart';

abstract class AdminUserRepo{
  Future<void> addUser(AddAdminUserData params);
  Future<void> deleteUser({required String id});
  Future<void> blockUser({required String id});
  Future<List<AdminUser>> getUsers();
}