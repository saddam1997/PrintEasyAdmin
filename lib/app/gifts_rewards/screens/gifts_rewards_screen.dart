import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/gifts_rewards/gift_rewards_controller.dart';
import 'package:printeasy_admin/app/gifts_rewards/widgets/empty_gift_reward_widget.dart';
import 'package:printeasy_admin/app/gifts_rewards/widgets/gift_rewards_list_grid_widget.dart';
import 'package:printeasy_admin/util/navigation/app_router.dart';
import 'package:printeasy_admin/util/navigation/pages.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class GiftsRewardsScreen extends StatelessWidget {
  const GiftsRewardsScreen({super.key});

  static const String route = AppRoutes.giftRewards;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GiftRewardsController>();

    return GetX<GiftRewardsController>(
      initState: (_){
        final controller = Get.find<GiftRewardsController>();
        controller.loadAllRewards();
      },
      builder: (c) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            controller.reset();
            AppRouter.goToAddGiftReward();
          },
          child: const Icon(Icons.add),
        ),
        body: controller.isLoading
            ? const Center(child: AppLoader())
            : controller.rewards.isEmpty
                ? const EmptyGiftRewardWidget()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: GiftRewardsListGridWidget(
                      rewards: controller.rewards,
                      onEdit: (reward) {
                        AppRouter.goToEditGiftReward(reward);
                      },
                      onDelete: (reward) {
                        _showDeleteConfirmation(context, reward);
                      },
                    ),
                  ),
      ),
    );
  }



  void _showDeleteConfirmation(BuildContext context, GiftRewardModel reward) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Reward?'),
        content: Text('Are you sure you want to delete "${reward.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // 🔥 Call your controller's delete method here
              Get.find<GiftRewardsController>().deleteReward(reward.id!);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
