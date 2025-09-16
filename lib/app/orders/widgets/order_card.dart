import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(
    this.order, {
    super.key,
    this.onStatusChange,
    this.onDownload,
  });

  final OrderModel order;
  final VoidCallback? onStatusChange;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) => TapHandler(
        onTap: () {
          Get.dialog(
            OrderDetailsDialog(order),
          );
        },
        child: SizedBox(
          height: 180,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  Image.network(
                    order.items.first.imageUrl,
                    width: context.isMobile ? 100 : 150,
                    height: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.shippingAddress?.name ?? '',
                                style: context.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (order.items.length == 1) ...[
                                Text(
                                  order.items.first.label,
                                  style: context.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${order.items.first.quantity} pack',
                                  style: context.titleSmall,
                                ),
                              ] else ...[
                                Text(
                                  '${order.items.length} items',
                                  style: context.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  order.items.map((e) => e.label).join(', '),
                                  style: context.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const Spacer(),
                              Text(
                                '${PrintEasyStrings.rupee} ${order.totalAmount}',
                                style: context.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              if (OrderStatus.actionableValues.contains(order.status)) ...[
                                AppButton.small(
                                  onTap: onStatusChange,
                                  label: order.status.actionLabel,
                                  icon: Icons.arrow_forward_rounded,
                                  backgroundColor: order.status.color,
                                  position: IconPosition.trailing,
                                ),
                              ] else ...[
                                Text(
                                  order.status.label,
                                  style: context.bodyLarge?.copyWith(
                                    color: order.status.color,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.picture_as_pdf_rounded,
                                color: AppColors.primary,
                              ),
                              onPressed: onDownload,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
