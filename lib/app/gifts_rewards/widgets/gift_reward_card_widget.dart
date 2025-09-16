import 'package:flutter/material.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class GiftRewardCardWidget extends StatelessWidget {
  const GiftRewardCardWidget({
    super.key,
    required this.reward,
    this.onEdit,
    this.onDelete,
  });

  final GiftRewardModel reward;
  final Function(GiftRewardModel)? onEdit;
  final Function(GiftRewardModel)? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = context.isDesktop;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onEdit?.call(reward),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isWide
              ? _buildWideLayout(theme, context)
              : _buildMobileLayout(theme, context),
        ),
      ),
    );
  }

  // 👇 Desktop / Tablet Layout
  Widget _buildWideLayout(ThemeData theme, BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          /// Title Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  spacing: 12,
                  children: [
                    _buildIcon(context),
                    Expanded(child: _buildTitle(theme, context)),
                  ],
                ),
              ),
              _buildActionButtons(context),
            ],
          ),
          _buildOtherDetails(context),
        ],
      );

  // 👇 Mobile Layout
  Widget _buildMobileLayout(ThemeData theme, BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            spacing: 12,
            children: [
              _buildIcon(context),
              Expanded(child: _buildTitle(theme, context)),
            ],
          ),
          _buildOtherDetails(context),
          Align(
              alignment: Alignment.centerRight,
              child: _buildActionButtons(context)),
        ],
      );

  Widget _buildIcon(BuildContext context) {
    final isWide = context.isDesktop;
    return CircleAvatar(
      radius: isWide ? 22 : 16,
      backgroundColor: reward.giftType.backgroundColor.withValues(alpha: 0.15),
      child: Icon(
        reward.icon,
        color: reward.giftType.color,
        size: isWide ? 22 : 16,
      ),
    );
  }

  Widget _buildTitle(ThemeData theme, BuildContext context) {
    final isWide = context.isDesktop;
    return Text(
      reward.title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: isWide ? 16 : 14,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isWide = context.isDesktop;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        IconButton(
          icon: Icon(
            Icons.edit,
            size: isWide ? 24 : 20,
          ),
          tooltip: 'Edit Reward',
          onPressed: () => onEdit?.call(reward),
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            size: isWide ? 24 : 20,
          ),
          tooltip: 'Delete Reward',
          onPressed: () => onDelete?.call(reward),
        ),
      ],
    );
  }

  Widget _buildOtherDetails(BuildContext context) {
    final isWidth = context.isDesktop;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 8),

        /// Minimum Order + Gift Type
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(Icons.shopping_cart,
                    size: isWidth ? 14 : 12, color: Colors.grey),
                Text(
                  'Min Order: ₹${reward.minOrderAmount.toStringAsFixed(0)}',
                  style: TextStyle(fontSize: isWidth ? 13 : 11),
                ),
              ],
            ),
            Text(
              reward.giftType.label,
              style: TextStyle(
                color: reward.giftType.color,
                fontWeight: FontWeight.w600,
                fontSize: isWidth ? 12 : 10,
              ),
            ),
          ],
        ),

        /// Discount
        if (reward.isDiscount)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              spacing: 4,
              children: [
                Icon(Icons.discount,
                    size: isWidth ? 14 : 12, color: Colors.grey),
                Text(
                  reward.discountPercentage != null
                      ? '${reward.discountPercentage!.toStringAsFixed(0)}% OFF'
                      : 'Flat ₹${reward.discountAmount!.toStringAsFixed(0)} OFF',
                  style: TextStyle(fontSize: isWidth ? 13 : 11),
                ),
              ],
            ),
          ),

        /// Product Gift
        if (reward.isProductGift)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Icon(Icons.card_giftcard,
                    size: isWidth ? 14 : 12, color: Colors.grey),
                Expanded(
                  child: Text(
                    'Gift Product ID: ${reward.productId ?? "N/A"}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: isWidth ? 13 : 11),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 8),

        /// Status + Created Date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 4,
              children: [
                Icon(
                  reward.isActive ? Icons.check_circle : Icons.cancel,
                  size: isWidth ? 14 : 12,
                  color: reward.isActive ? Colors.green : Colors.red,
                ),
                Text(
                  reward.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: reward.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: isWidth ? 12 : 10,
                  ),
                ),
              ],
            ),
            Text(
              'Created: ${reward.createdAt.toLocal().toString().split(' ').first}',
              style: TextStyle(fontSize: isWidth ? 12 : 10, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
