import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/gifts_rewards/widgets/gift_reward_card_widget.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class GiftRewardsListGridWidget extends StatelessWidget {
  const GiftRewardsListGridWidget({
    super.key,
    required this.rewards,
    this.onEdit,
    this.onDelete,
  });

  final List<GiftRewardModel> rewards;
  final Function(GiftRewardModel)? onEdit;
  final Function(GiftRewardModel)? onDelete;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: rewards
              .map((reward) => GiftRewardCardWidget(
                    reward: reward,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ))
              .toList(),
        ),
      );
}
