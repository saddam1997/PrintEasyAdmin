import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';

class ProductBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProductController(
        ProductViewModel(
          ProductRepository(),
        ),
      ),
    );
  }
}
