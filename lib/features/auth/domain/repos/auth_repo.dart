import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo{
  Future<UserCredential> login({required String email, required String password});
  Future<void> logout();
  Future<bool> isLoggedIn();
}