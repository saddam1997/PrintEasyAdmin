import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class BannerDialog extends StatelessWidget {
  const BannerDialog({super.key});

  @override
  Widget build(BuildContext context) => GetX<BannerController>(
        builder: (controller) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Banner',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (controller.bannerImage.isEmpty) ...[
              const Text(
                'No banner image selected',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              Image.memory(
                controller.bannerImage,
                height: 100,
                width: 200,
              ),
            ],
            const SizedBox(height: 16),
            AppButton.small(
              onTap: controller.pickBannerImage,
              label: 'Pick Banner Image',
              backgroundColor: AppColors.background,
              borderColor: AppColors.primary,
              foregroundColor: AppColors.primary,
            ),
            const SizedBox(height: 24),
            AppButton(
              onTap: () {
                Get.back();
                controller.uploadBannerImage();
              },
              label: 'Upload Image',
            ),
          ],
        ),
      );
}
