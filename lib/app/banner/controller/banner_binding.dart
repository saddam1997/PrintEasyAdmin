import 'package:get/get.dart';
import 'package:printeasy_admin/app/banner/banner_repository.dart';
import 'package:printeasy_admin/app/banner/banner_viewmodel.dart';
import 'package:printeasy_admin/app/banner/controller/banner_controller.dart';

class BannerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => BannerController(
        BannerViewmodel(
          BannerRepository(),
        ),
      ),
    );
  }
}
