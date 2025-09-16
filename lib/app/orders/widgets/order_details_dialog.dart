import 'package:flutter/material.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class OrderDetailsDialog extends StatelessWidget {
  const OrderDetailsDialog(this.order, {super.key});

  final OrderModel order;

  @override
  Widget build(BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                order.shippingAddress?.name ?? '',
                style: context.titleLarge,
              ),
              SelectableText(
                order.shippingAddress?.mobile ?? '',
                style: context.bodyLarge,
              ),
              SelectableText(
                order.shippingAddress?.fullAddress ?? '',
                style: context.bodyLarge,
              ),
              const SizedBox(height: 16),
              SelectableText(
                'DTDC Id:  ${order.shipmentId}',
                style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SelectableText(
                'Razorpay Order Id:  ${order.razorpay?.orderId}',
                style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SelectableText(
                'Razorpay Payment Id:  ${order.razorpay?.paymentId}',
                style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
