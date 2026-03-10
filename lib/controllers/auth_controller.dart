import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/screens/home_screen.dart';
import '../view/screens/login_screen.dart';

class AuthController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  User? get currentUser => _auth.currentUser;

  /// LOGIN
  Future<void> login(String email, String password) async {

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and Password required");
      return;
    }

    try {

      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      /// SUCCESS SNACKBAR
      Get.snackbar(
        "Success",
        "Login Successful",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      /// NAVIGATE HOME
      Get.offAll(() => const HomeScreen());

    } on FirebaseAuthException catch (e) {

      String message = "Login Failed";

      if (e.code == "user-not-found") {
        message = "User not found";
      } else if (e.code == "wrong-password") {
        message = "Wrong password";
      } else if (e.code == "invalid-email") {
        message = "Invalid email format";
      }

      Get.snackbar("Error", message);

    } catch (e) {

      Get.snackbar("Error", e.toString());

    } finally {

      isLoading.value = false;

    }
  }

  /// SIGNUP
  Future<void> signup(String email, String password) async {

    try {

      isLoading.value = true;

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar(
        "Success",
        "Account created successfully",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => const HomeScreen());

    } on FirebaseAuthException catch (e) {

      String message = "Signup Failed";

      if (e.code == "email-already-in-use") {
        message = "Email already registered";
      } else if (e.code == "weak-password") {
        message = "Password should be at least 6 characters";
      } else if (e.code == "invalid-email") {
        message = "Invalid email address";
      }

      Get.snackbar("Error", message);

    } finally {

      isLoading.value = false;

    }
  }

  /// LOGOUT
  Future<void> logout() async {

    await _auth.signOut();

    Get.offAll(() => const LoginScreen());

    Get.snackbar(
      "Logout",
      "You have logged out",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}