import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SplashController.new);
  }
}
