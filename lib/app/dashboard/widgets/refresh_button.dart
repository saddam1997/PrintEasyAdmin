import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AppRefreshButton extends StatelessWidget {
  const AppRefreshButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) => GetBuilder<DashboardController>(
        builder: (controller) => ResponsiveBuilder(
          mobile: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.white,
            ),
            onPressed: () => controller.onRefresh(controller.selectedItem),
            icon: const Icon(Icons.refresh_rounded),
          ),
          tablet: AppButton.small(
            onTap: () => controller.onRefresh(controller.selectedItem),
            icon: Icons.refresh_rounded,
            label: controller.selectedItem.label,
          ),
        ),
      );
}
