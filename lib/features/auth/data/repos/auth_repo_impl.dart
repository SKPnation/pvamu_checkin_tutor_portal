import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pvamu_checkin_tutor_portal/features/auth/domain/repos/auth_repo.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/models/admin_user_model.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/repos/admin_users_repo_impl.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/data/repos/user_data_store.dart';
import 'package:pvamu_checkin_tutor_portal/features/settings/domain/entities/add_admin_user_data.dart';

class AuthRepoImpl extends AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final CollectionReference adminUserCollection = FirebaseFirestore.instance
      .collection('admin_users');
  AdminUserRepoImpl adminUserRepo = AdminUserRepoImpl();

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<bool> isLoggedIn() async {
    final user = firebaseAuth.currentUser;
    return user != null;
  }

  Future<UserCredential?> loginOrRegister(String email, String password) async {
    try {
      // Try sign in
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential; // success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // No user → register instead
        final newUserCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        return newUserCredential;
      } else if (e.code == 'wrong-password') {
        // No user → register instead
        final newUserCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        return newUserCredential;
      } else {
        // No user → register instead
        final newUserCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        return newUserCredential;
      }
    }
  }

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    var existsInDB = await checkIfUserExistsInDB(email: email);
    if (existsInDB.isNotEmpty) {
      ///EXISTS IN DB
      UserCredential? userCredential = await loginOrRegister(email, password);
      return userCredential!;
    } else {
      ///DOES NOT EXIST IN DB
      UserCredential userCredential = await signInWithFirebaseAuth(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        //NOT AUTHENTICATED
        throw Exception("No user found for that email.");
      } else {
        //IS AUTHENTICATED
        var user = await adminUserRepo.addUser(
          AddAdminUserData(
            id: userCredential.user!.uid,
            email: email,
            password: password,
            firstName: "",
            lastName: "",
            level: 2,
          ),
        );

        userDataStore.user = user;

        return userCredential;
      }
    }
  }

  Future<UserCredential> signInWithFirebaseAuth({
    required String email,
    required String password,
  }) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;
  }


  Future<Map<String, dynamic>> checkIfUserExistsInDB({
    required String email,
  }) async {
    final studentsQuery = adminUserCollection
        .where('email', isEqualTo: email)
        .limit(1);

    final QuerySnapshot querySnapshot = await studentsQuery.get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the first document (since you limited to 1)
      final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // Extract the data from the document as a Map
      // Also, add the document ID to the map if you need it
      final Map<String, dynamic> docAsJson =
          documentSnapshot.data() as Map<String, dynamic>;

      docAsJson['id'] = documentSnapshot.id; // Optional: include document ID

      userDataStore.user = docAsJson; // Be careful with global state like this

      return docAsJson;
    } else {
      userDataStore.user = {};
      // No document found with that email
      return {}; // It's better to return null if no user is found
    }
  }
}
