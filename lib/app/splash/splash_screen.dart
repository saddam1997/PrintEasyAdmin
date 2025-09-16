import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String route = AppRoutes.splash;

  @override
  Widget build(BuildContext context) => GetBuilder<SplashController>(
        builder: (context) => const Scaffold(
          body: Center(
            child: Hero(
              key: ValueKey('AppLogo'),
              tag: 'app-logo',
              child: AppLogo(),
            ),
          ),
        ),
      );
}
