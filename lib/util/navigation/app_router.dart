import 'package:get/get.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AppRouter {
  const AppRouter._();

  static void goToAuth([bool offAll = false]) {
    if (offAll) {
      Get.offAllNamed(AppRoutes.auth);
    } else {
      Get.toNamed(AppRoutes.auth);
    }
  }

  static void goToDashboard() {
    Get.toNamed(AppRoutes.dashboard);
  }

  static void goToSupport() {
    Get.toNamed(AppRoutes.support);
  }

  static void goToAddProduct([ProductModel? product]) {
    Get.toNamed(
      AppRoutes.addProduct,
      arguments: {
        'product': product?.toMap(),
      },
    );
  }

  static void goToAddFranchise() {
    Get.toNamed(AppRoutes.addFranchise);
  }

  static void goToEditFranchise(FranchiseModel franchise) {
    Get.toNamed(
      AppRoutes.addFranchise,
      arguments: {
        'franchise': franchise.toMap(),
      },
    );
  }

  static void goToSearchAddress() {
    Get.toNamed(AppRoutes.searchAddress);
  }

  static void goToAddGiftReward() {
    Get.toNamed(
      AppRoutes.addGiftReward,
    );
  }

  static void goToEditGiftReward(GiftRewardModel giftReward) {
    Get.toNamed(
      AppRoutes.addGiftReward,
      arguments: {
        'giftReward': giftReward.toMap(),
      },
    );
  }

  static void goToAddPromoHeadline() {
    Get.toNamed(
      AppRoutes.addPromoHeadline,
    );
  }

  static void goToEditPromoHeadline(PromoHeadlineModel promoHeadline) {
    Get.toNamed(
      AppRoutes.addPromoHeadline,
      arguments: {
        'promoHeadline': promoHeadline.toMap(),
      },
    );
  }
}
