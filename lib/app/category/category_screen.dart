import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const String updateId = 'category_update_id';

  @override
  Widget build(BuildContext context) => GetBuilder<CategoryController>(
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
                        child: ReorderableListView.builder(
                          itemCount: controller.categories.length,
                          onReorder: controller.reorderCategories,
                          footer: Align(
                            alignment: Alignment.centerLeft,
                            child: UnconstrainedBox(
                              child: AppButton.small(
                                onTap: () {
                                  Get.dialog(
                                    const DialogWrapper(
                                      child: CategoryDialog(),
                                    ),
                                  );
                                },
                                label: 'Add Category',
                                backgroundColor: AppColors.background,
                                borderColor: AppColors.primary,
                                foregroundColor: AppColors.primary,
                              ),
                            ),
                          ),
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
                                  controller.onCategoryTap(category);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      if (controller.selectedSubcategory != null) ...[
                        context.isDesktop ? const VerticalDivider() : const Divider(),
                        Expanded(
                          flex: 3,
                          child: SubcategorySection(
                            controller.selectedSubcategory!,
                            category: controller.selectedCategory!,
                          ),
                        ),
                      ] else if (controller.selectedCollection != null) ...[
                        context.isDesktop ? const VerticalDivider() : const Divider(),
                        Expanded(
                          flex: 3,
                          child: CollectionSection(controller.selectedCollection!),
                        ),
                      ] else if (controller.selectedCategory != null) ...[
                        context.isDesktop ? const VerticalDivider() : const Divider(),
                        Expanded(
                          flex: 3,
                          child: CategorySection(controller.selectedCategory!),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      );
}
