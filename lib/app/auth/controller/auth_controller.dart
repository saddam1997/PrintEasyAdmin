import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';

class AuthController extends GetxController {
  final loginKey = GlobalKey<FormState>();

  final emailTEC = TextEditingController();
  final passwordTEC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    DBWrapper.i.saveValue(AppKeys.isLoggedIn, false);
  }

  void onLogin() async {
    if (!(loginKey.currentState?.validate() ?? false)) {
      return;
    }
    final isLoggedIn = await AuthService.i.login(
      emailTEC.text.trim(),
      passwordTEC.text.trim(),
    );
    if (isLoggedIn) {
      AppRouter.goToDashboard();
    }
  }
}
