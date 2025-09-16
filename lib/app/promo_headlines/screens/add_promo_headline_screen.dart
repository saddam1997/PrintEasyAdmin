import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_controller.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AddPromoHeadlineScreen extends StatelessWidget {
  const AddPromoHeadlineScreen({
    super.key,
    this.promoHeadlineModel,
  });

  final PromoHeadlineModel? promoHeadlineModel;

  static const String route = AppRoutes.addPromoHeadline;

  @override
  Widget build(BuildContext context) => GetBuilder<PromoHeadlinesController>(
        initState: (_) {
          final controller = Get.find<PromoHeadlinesController>();
          controller.initializeForm(promoHeadlineModel);
        },
        builder: (controller) {
          final isEditing = controller.selectedHeadline != null;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                isEditing ? 'Edit Headline' : 'Add Headline',

              ),
              leading: const BackButton(),
              actions: [
                AppButton.small(
                  label: isEditing ? 'Update' : 'Save',
                  onTap: () => controller.submitHeadline(),
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
                    InputField(
                      label: 'Promo Headline',
                      controller: controller.headlineController,
                      validator: AppValidators.userName,
                    ),
                    const SizedBox(height: 16),
                    ProductSwitch(
                      label: 'Is Active?',
                      value: controller.isActive,
                      onChanged: controller.toggleActiveStatus,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
