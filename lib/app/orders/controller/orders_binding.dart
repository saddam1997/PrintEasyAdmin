import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';

class OrdersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => OrdersController(
        ordersViewModel: OrdersViewModel(
          OrdersRepository(),
        ),
        productViewModel: ProductViewModel(
          ProductRepository(),
        ),
      ),
    );
  }
}
