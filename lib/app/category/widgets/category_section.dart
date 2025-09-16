import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CategorySection extends StatelessWidget {
  const CategorySection(this.category, {super.key});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) => GetBuilder<CategoryController>(
        id: CategoryScreen.updateId,
        builder: (controller) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    controller.onCategoryTap(null);
                  },
                  icon: const Icon(Icons.close),
                ),
                AppButton.small(
                  onTap: () {
                    Get.dialog(
                      DialogWrapper(
                        child: CategoryDialog(
                          category: category,
                        ),
                      ),
                    );
                  },
                  label: 'Edit Category',
                  backgroundColor: AppColors.background,
                  borderColor: AppColors.primary,
                  foregroundColor: AppColors.primary,
                ),
              ],
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category: ${category.name}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            category.isActive ? 'Active' : 'Inactive',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: category.isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _SubcategoriesSliver(category.subCategories),
                  const SliverToBoxAdapter(child: Divider()),
                  const _CollectionsHeader(section: 1),
                  _CollectionsSliver(controller.section1Collections, section: 1),
                  const SliverToBoxAdapter(child: Divider()),
                  const _CollectionsHeader(section: 2),
                  _CollectionsSliver(controller.section2Collections, section: 2),
                  const SliverToBoxAdapter(child: Divider()),
                  const _CollectionsHeader(section: 3),
                  _CollectionsSliver(controller.section3Collections, section: 3),
                  const SliverToBoxAdapter(child: Divider()),
                  _ConfigurationsSliver(category.configurations),
                  const SliverToBoxAdapter(child: Divider()),
                  const _IllustrationHeader(),
                  _IllustrationsSliver(category.illustrations),
                  _AddIllustration(illustrations: category.illustrations),
                ],
              ),
            ),
          ],
        ),
      );
}

class _SubcategoriesSliver extends StatelessWidget {
  const _SubcategoriesSliver(this.subCategories);

  final List<SubcategoryModel> subCategories;

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            const Text(
              'Subcategories',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...subCategories.map(
              (e) {
                final controller = Get.find<CategoryController>();
                final isSelected = controller.selectedSubcategory?.id == e.id;
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    e.name,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.black,
                    ),
                  ),
                  tileColor: isSelected ? AppColors.primary : null,
                  onTap: () {
                    controller.onSubcategoryTap(e);
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            AppButton.small(
              onTap: () {
                final controller = Get.find<CategoryController>();
                final category = controller.selectedCategory;
                if (category == null) {
                  return;
                }
                if (category.configurations.isEmpty) {
                  Utility.showInfoDialog(DialogModel.error('Add configurations to proceed'));
                  return;
                }

                Get.dialog(
                  DialogWrapper(
                    child: SubcategoryDialog(
                      category,
                    ),
                  ),
                );
              },
              label: 'Add Subcategory',
              backgroundColor: AppColors.background,
              borderColor: AppColors.primary,
              foregroundColor: AppColors.primary,
            )
          ]),
        ),
      );
}

class _CollectionsHeader extends StatelessWidget {
  const _CollectionsHeader({required this.section});

  final int section;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Collections $section',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppButton.small(
              onTap: () {
                Get.dialog(
                  DialogWrapper(
                    child: CollectionDialog(
                      section: section,
                    ),
                  ),
                );
              },
              label: 'Add Collection',
              backgroundColor: AppColors.background,
              borderColor: AppColors.primary,
              foregroundColor: AppColors.primary,
            ),
          ],
        ),
      );
}

class _CollectionsSliver extends StatelessWidget {
  const _CollectionsSliver(
    this.collections, {
    required this.section,
  });

  final int section;
  final List<CollectionModel> collections;

  int _crossAxisCount(BuildContext context) => switch (context.type) {
        LayoutType.mobileSmall => 1,
        LayoutType.mobile => 1,
        LayoutType.tablet => 2,
        LayoutType.desktop => 1,
        LayoutType.desktopLarge => 2,
      };

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverGrid.builder(
          itemCount: collections.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _crossAxisCount(context),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final collection = collections[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppImage(
                          collection.image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          scale: 0.25,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Switch(
                            activeTrackColor: AppColors.primary,
                            value: collection.isActive,
                            onChanged: (value) {
                              Get.find<CategoryController>().onChangeIsActive(
                                collectionId: collection.id,
                                value: value,
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          AppButton.small(
                            onTap: () {
                              Get.find<CategoryController>().onCollectionTap(collection);
                            },
                            label: 'Products',
                            backgroundColor: AppColors.background,
                            borderColor: AppColors.primary,
                            foregroundColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              collection.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              collection.description,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          Get.dialog(
                            DialogWrapper(
                              child: CollectionDialog(
                                collection: collection,
                                section: section,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _ConfigurationsSliver extends StatelessWidget {
  const _ConfigurationsSliver(this.configurations);

  final List<OptionsModel> configurations;

  @override
  Widget build(BuildContext context) => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            const Text(
              'Configurations',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...configurations.map(
              (e) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.text),
                        IconButton(
                          onPressed: () {
                            Get.dialog(
                              DialogWrapper(
                                child: ConfigurationDialog(e),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: e.options
                          .map(
                            (e) => Chip(
                              label: Text(
                                e.text,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton.small(
              onTap: () {
                Get.dialog(
                  const DialogWrapper(
                    child: ConfigurationDialog(
                      OptionsModel(),
                      isNew: true,
                    ),
                  ),
                );
              },
              label: 'Add Configuration',
              backgroundColor: AppColors.background,
              borderColor: AppColors.primary,
              foregroundColor: AppColors.primary,
            ),
          ]),
        ),
      );
}

class _IllustrationHeader extends StatelessWidget {
  const _IllustrationHeader();

  @override
  Widget build(BuildContext context) => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Illustrations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
}

class _IllustrationsSliver extends StatelessWidget {
  const _IllustrationsSliver(this.illustrations);

  final List<IllustrationModel> illustrations;

  @override
  Widget build(BuildContext context) {
    if (illustrations.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('No illustrations found'),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverGrid.builder(
        itemCount: illustrations.take(30).length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final illustration = illustrations[index];
          return AppImage(
            illustration.imageUrl,
            fit: BoxFit.contain,
            width: 100,
            height: 100,
            scale: 0.125,
          );
        },
      ),
    );
  }
}

class _AddIllustration extends StatelessWidget {
  const _AddIllustration({
    required this.illustrations,
  });

  final List<IllustrationModel> illustrations;

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: AppButton.small(
                  onTap: () {
                    Get.find<CategoryController>().onAddIllustration();
                  },
                  label: 'Add Illustration',
                  backgroundColor: AppColors.background,
                  borderColor: AppColors.primary,
                  foregroundColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton.small(
                  onTap: () {
                    if (illustrations.isEmpty) {
                      return;
                    }
                    Get.dialog(
                      DialogWrapper(
                        child: IllustrationDialog(illustrations: illustrations),
                      ),
                    );
                  },
                  label: 'View All',
                  backgroundColor: AppColors.background,
                  borderColor: AppColors.primary,
                  foregroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
}
