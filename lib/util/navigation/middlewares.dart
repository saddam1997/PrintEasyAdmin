import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';

class StrictAuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    try {
      if (DBWrapper.i.getValue<bool>(AppKeys.isLoggedIn) ?? false) {
        final time = DateTime.fromMillisecondsSinceEpoch(DBWrapper.i.getValue<int>(AppKeys.sessionTime) ?? 0);
        if (DateTime.now().difference(time).inMinutes < 60) {
          return null;
        }
      }
      return const RouteSettings(name: AppRoutes.auth);
    } catch (_) {
      return const RouteSettings(name: AppRoutes.auth);
    }
  }
}
