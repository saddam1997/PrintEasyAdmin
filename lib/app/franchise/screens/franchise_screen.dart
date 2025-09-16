import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class FranchiseScreen extends StatelessWidget {
  const FranchiseScreen({super.key});

  static const String route = AppRoutes.franchise;

  @override
  Widget build(BuildContext context) => GetX<FranchiseController>(
        builder: (controller) => Scaffold(
          body: controller.isLoading
              ? const AppLoader()
              : controller.franchises.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('No franchises found'),
                          SizedBox(height: 16),
                          AppButton.small(
                            onTap: AppRouter.goToAddFranchise,
                            label: 'Add Franchise',
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Flex(
                        direction: context.isDesktop ? Axis.horizontal : Axis.vertical,
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomScrollView(
                              slivers: [
                                SliverList.builder(
                                  itemCount: controller.franchises.length,
                                  itemBuilder: (_, index) {
                                    final franchise = controller.franchises[index];
                                    final isSelected = controller.selectedFranchise?.id == franchise.id;
                                    return Padding(
                                      key: ValueKey(franchise.id),
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: ListTile(
                                        onTap: () => controller.selectedFranchise = franchise,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        title: Text(
                                          franchise.name,
                                          style: TextStyle(
                                            color: isSelected ? AppColors.white : AppColors.black,
                                          ),
                                        ),
                                        tileColor: isSelected ? AppColors.primary : null,
                                      ),
                                    );
                                  },
                                ),
                                const SliverToBoxAdapter(
                                  child: SizedBox(height: 16),
                                ),
                                const SliverToBoxAdapter(
                                  child: UnconstrainedBox(
                                    child: AppButton.small(
                                      onTap: AppRouter.goToAddFranchise,
                                      label: 'Add Franchise',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (controller.selectedFranchise != null) ...[
                            context.isDesktop ? const VerticalDivider() : const Divider(),
                            Expanded(
                              flex: 3,
                              child: _FranchiseSection(controller.selectedFranchise!),
                            ),
                          ],
                        ],
                      ),
                    ),
        ),
      );
}

class _FranchiseSection extends StatelessWidget {
  const _FranchiseSection(this.franchise);

  final FranchiseModel franchise;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.find<FranchiseController>().selectedFranchise = null;
                },
                icon: const Icon(Icons.close),
              ),
              AppButton.small(
                onTap: () => AppRouter.goToEditFranchise(franchise),
                label: 'Edit Franchise',
                backgroundColor: AppColors.background,
                borderColor: AppColors.primary,
                foregroundColor: AppColors.primary,
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    franchise.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Address(address: franchise.address),
                  const SizedBox(height: 16),
                  Text(
                    'Coupon Code: ${franchise.couponCode}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Commission: ${franchise.commission}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Discount: ${franchise.discount}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Amount: Rs ${franchise.settledAmount + franchise.unsettledAmount}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Settled Amount: Rs ${franchise.settledAmount}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Unsettled Amount: Rs ${franchise.unsettledAmount}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  // const SizedBox(height: 16),
                  // AppButton.small(
                  //   onTap: () => AppRouter.goToAddFranchise(franchise: franchise),
                  //   label: 'Settle Amount',
                  // ),
                ],
              ),
            ),
          ),
        ],
      );
}

class _Address extends StatelessWidget {
  const _Address({
    required this.address,
  });

  final AddressModel address;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mobile: ${address.mobile}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Email: ${address.email}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Address: ${address.fullAddress}',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      );
}
