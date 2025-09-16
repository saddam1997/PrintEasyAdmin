import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/app/gifts_rewards/gift_rewards_controller.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AddGiftRewardsScreen extends StatelessWidget {
  const AddGiftRewardsScreen({
    super.key,
    this.giftRewardModel,
  });

  final GiftRewardModel? giftRewardModel;

  static String route = AppRoutes.addGiftReward;

  @override
  Widget build(BuildContext context) => GetBuilder<GiftRewardsController>(
        initState: (_) {
          final controller = Get.find<GiftRewardsController>();
          controller.initGiftReward(giftRewardModel);
        },
        builder: (controller) {
          final isEditing = controller.selectedReward != null;
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Edit Gift Reward' : 'Add Gift Reward'),
              leading: const BackButton(),
              actions: [
                AppButton.small(
                  label: isEditing ? 'Update' : 'Save',
                  onTap: () => controller.submitGiftReward(),
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropDown<GiftType>(
                      label: 'Gift Type',
                      value: controller.giftType,
                      items: GiftType.values,
                      itemBuilder: (_, type) => Text(type.label),
                      onChanged: controller.setGiftType,
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Title',
                      controller: controller.titleController,
                      validator: AppValidators.userName,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Minimum Order Amount (₹)',
                      controller: controller.minOrderController,
                      textInputType: TextInputType.number,
                      validator: AppValidators.numberRequired,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Conditional discount inputs
                    if (controller.isDiscount) ...[
                      InputField(
                        label: 'Discount Percentage (%)',
                        controller: controller.discountPercentageController,
                        textInputType: TextInputType.number,
                        validator: AppValidators.optionalNumber,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      InputField(
                        label: 'Flat Discount Amount (₹)',
                        controller: controller.discountAmountController,
                        textInputType: TextInputType.number,
                        validator: AppValidators.optionalNumber,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Conditional product gift input
                    if (controller.isProductGift) ...[
                      InputField(
                        label: 'Gift Product ID',
                        controller: controller.productIdController,
                        validator: AppValidators.optionalText,
                      ),
                      const SizedBox(height: 16),
                    ],

                    ProductSwitch(
                      label: 'Is Active?',
                      value: controller.isActive,
                      onChanged: controller.setIsActive,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
