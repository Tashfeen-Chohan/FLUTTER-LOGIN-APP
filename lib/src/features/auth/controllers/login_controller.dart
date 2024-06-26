import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_app/src/repository/auth_repository/auth_repo.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    String? error = await AuthRepository.instance
        .signInWithEmailAndPassword(email, password);
    if (error != null) {
      Get.snackbar("Error", error.toString());
    } else {
      this.email.text = "";
      this.password.text = "";
    }
  }
}
