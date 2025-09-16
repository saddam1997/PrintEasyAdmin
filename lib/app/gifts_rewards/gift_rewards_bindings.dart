import 'package:get/get.dart';
import 'package:printeasy_admin/app/gifts_rewards/gift_rewards_controller.dart';
import 'package:printeasy_admin/app/gifts_rewards/gifts_rewards_repository.dart';
import 'package:printeasy_admin/app/gifts_rewards/gifts_rewards_viewmodel.dart';

class GiftRewardsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => GiftRewardsController(
        GiftRewardsViewModel(
          GiftRewardRepository(),
        ),
      ),
    );
  }
}
