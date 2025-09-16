import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  static const String updateId = 'banner_update_id';

  @override
  Widget build(BuildContext context) => GetBuilder<BannerController>(
        id: updateId,
        builder: (controller) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: controller.categories.isEmpty
                ? const AppLoader()
                : Flex(
                    direction: context.isDesktop ? Axis.horizontal : Axis.vertical,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListView.builder(
                          itemCount: controller.categories.length,
                          itemBuilder: (context, index) {
                            final category = controller.categories[index];
                            final isSelected = controller.selectedCategory?.id == category.id;
                            return Padding(
                              key: ValueKey(category.id),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isSelected ? AppColors.white : AppColors.black,
                                  ),
                                ),
                                tileColor: isSelected ? AppColors.primary : null,
                                onTap: () {
                                  controller.selectCategory(category);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      if (controller.selectedCategory != null) ...[
                        context.isDesktop ? const VerticalDivider() : const Divider(),
                        Expanded(
                          flex: 3,
                          child: _CategoryBanners(category: controller.selectedCategory!),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      );
}

class _CategoryBanners extends StatelessWidget {
  const _CategoryBanners({
    required this.category,
  });

  final CategoryModel category;

  @override
  Widget build(BuildContext context) => Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category: ${category.name}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: GetBuilder<BannerController>(
              id: BannerScreen.updateId,
              builder: (controller) => ReorderableListView.builder(
                itemCount: controller.banners.length,
                onReorder: controller.reorderBanners,
                footer: Align(
                  alignment: Alignment.centerLeft,
                  child: UnconstrainedBox(
                    child: AppButton.small(
                      onTap: () async {
                        await Get.dialog(
                          const DialogWrapper(
                            child: BannerDialog(),
                          ),
                        );
                        controller.bannerImage = Uint8List(0);
                      },
                      label: 'Add Banner',
                      backgroundColor: AppColors.background,
                      borderColor: AppColors.primary,
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                itemBuilder: (context, index) {
                  final banner = controller.banners[index];
                  return Padding(
                    key: ValueKey(banner.id),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppImage(
                          banner.imageUrl,
                          height: 100,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Is Active?',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              activeTrackColor: AppColors.primary,
                              value: banner.isActive,
                              onChanged: (value) {
                                controller.onChangeIsActive(
                                  bannerId: banner.id,
                                  categoryId: category.id,
                                  value: value,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );
}
