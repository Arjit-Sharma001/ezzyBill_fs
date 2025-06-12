import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezzybill/consts/firebaseConst.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  // Text controllers for login inputs
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // Dispose controllers to avoid memory leaks
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Login method using email and password
  Future<UserCredential?> loginMethod({required BuildContext context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorToast(context, e.message ?? "Login failed");
      print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr: ${e.message}");
    }
    return userCredential;
  }

  // Sign up method
  Future<UserCredential?> signUpMethod({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      _showErrorToast(context, e.message ?? "Signup failed");
    }
    return userCredential;
  }

  // Store user data in Firestore **without storing password**
  Future<void> storeUserData({
    required String name,
    required String email,
  }) async {
    final user = currentUser;
    if (user == null) return; // Safety check

    final DocumentReference store =
        firestore.collection(usersCollection).doc(user.uid);

    // Removed password storage for security
    await store.set({
      'name': name.trim(),
      'email': email.trim(),
      'profileUrl': '2', // placeholder
      'id': user.uid,
      'createdAt': Timestamp.now(),
    });
  }

  // Sign out method
  Future<void> signOutMethod(BuildContext context) async {
    try {
      await auth.signOut();
    } catch (e) {
      _showErrorToast(context, e.toString());
    }
  }

  // Common function to show error messages via SnackBar
  void _showErrorToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.redAccent,
    ));
  }
}
