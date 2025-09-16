import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';

class DashboardBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(DashboardController.new);
  }
}
