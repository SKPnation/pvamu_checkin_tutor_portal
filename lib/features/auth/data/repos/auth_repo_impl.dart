import 'package:firebase_auth/firebase_auth.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/domain/repos/auth_repo.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = firebaseAuth.currentUser;
    return user != null;
  }

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // You can handle specific errors if needed
      if (e.code == 'user-not-found') {
        throw Exception("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided.");
      } else {
        throw Exception(e.message);
      }
    }
  }

  void checkIfUserExistsInDB({required String email}) {
    /*
    * TODO: Check if it exists in the DB
    *  If yes; check if it exists in firebase authentication, if yes; sign in
    *  If no; do nothing
    *
    * */

  }
}
