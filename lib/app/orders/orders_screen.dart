import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<OrdersController>(
        builder: (controller) => Scaffold(
          body: DefaultTabController(
            length: OrderStatus.visibleValues.length,
            initialIndex: OrderStatus.visibleValues.indexOf(controller.selectedStatus),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    isScrollable: context.isMobile,
                    tabAlignment: context.isMobile ? TabAlignment.start : null,
                    dividerHeight: 0,
                    splashBorderRadius: BorderRadius.circular(40),
                    labelColor: AppColors.white,
                    unselectedLabelColor: AppColors.primary,
                    onTap: (index) => controller.onStatusTap(
                      OrderStatus.visibleValues[index],
                    ),
                    tabs: OrderStatus.visibleValues
                        .map(
                          (e) => Tab(
                            text: e.label,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: OrderStatus.visibleValues
                        .map(
                          (e) => _OrdersBody(
                            e,
                            key: ValueKey(e.name),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _OrdersBody extends StatelessWidget {
  const _OrdersBody(
    this.status, {
    super.key,
  });

  final OrderStatus status;

  @override
  Widget build(BuildContext context) => GetBuilder<OrdersController>(
        id: status.name,
        builder: (controller) {
          final combinedOrders = controller.orders(status);
          return combinedOrders.isEmpty
              ? Center(
                  child: Text('No ${status.name} Orders'),
                )
              : ListView.separated(
                  itemCount: combinedOrders.length,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final orders = combinedOrders[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              orders.first.orderDate?.toLocal().formatDate ?? '',
                              style: context.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              onPressed: () => controller.downloadMultiplePdf(context, orders),
                              icon: const Icon(
                                Icons.download_rounded,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            var crossAxisCount = max((constraints.maxWidth / 350).floor(), 1);

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisExtent: 180,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: orders.length,
                              itemBuilder: (_, innerIndex) {
                                final order = orders[innerIndex];
                                return OrderCard(
                                  order,
                                  onStatusChange: () => controller.onStatusChange(order),
                                  onDownload: () => controller.downloadSinglePdf(context, order),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
        },
      );
}
