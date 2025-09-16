import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';

class CategoryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CategoryController(
        categoryViewModel: CategoryViewModel(
          CategoryRepository(),
        ),
        productViewModel: ProductViewModel(
          ProductRepository(),
        ),
      ),
    );
  }
}
