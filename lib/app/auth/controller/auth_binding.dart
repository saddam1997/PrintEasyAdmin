import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(AuthController.new);
  }
}
