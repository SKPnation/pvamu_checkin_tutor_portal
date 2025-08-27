import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pvamu_checkin_tutor_portal/core/global/custom_snackbar.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/domain/entities/add_admin_user_data.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/domain/repos/admin_users_repo.dart';

class AdminUserRepoImpl extends AdminUserRepo {
  final CollectionReference adminUserCollection = FirebaseFirestore.instance
      .collection('admin_users');
  DocumentReference<Map<String, dynamic>> adminUserRef(String userId) =>
      FirebaseFirestore.instance.doc('/admin_users/$userId');

  @override
  Future<void> addUser( AddAdminUserData params) async {
    try {

      final data = params.toJson();
      final docRef = adminUserCollection.doc(data['id'] ?? adminUserCollection.doc().id);

      await docRef.set(data);

      Get.back(); //return
      CustomSnackBar.successSnackBar(body: "Added new member");
    } catch (e) {
      CustomSnackBar.errorSnackBar("Failed: $e");
    }
  }

  @override
  Future<void> blockUser({required String id}) async{
    final data = <String, dynamic>{"blocked_at": DateTime.now()};

    await adminUserCollection.doc(id).update(data);
  }

  @override
  Future<void> deleteUser({required String id}) async{
    await adminUserRef(id).delete();
  }

  @override
  Future<List<AdminUser>> getUsers() async{
    final querySnapshot = await adminUserCollection.get();
    List<AdminUser> admins =
    querySnapshot.docs.map((doc) {
      return AdminUser.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    return admins;
  }
}
