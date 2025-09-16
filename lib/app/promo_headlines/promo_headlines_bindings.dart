import 'package:get/get.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_controller.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_repository.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_viewmodel.dart';

class PromoHeadlinesBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => PromoHeadlinesController(
        PromoHeadlinesViewModel(
          PromoHeadlinesRepository(),
        ),
      ),
    );
  }
}
