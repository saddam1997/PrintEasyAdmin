import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';

class FranchiseBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FranchiseController(
        FranchiseViewModel(
          FranchiseRepository(),
        ),
      ),
    );
  }
}
