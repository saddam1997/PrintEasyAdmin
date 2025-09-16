import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CollectionSection extends StatelessWidget {
  const CollectionSection(
    this.collection, {
    super.key,
  });

  final CollectionModel collection;

  static const String updateId = 'collection-section-update-id';

  @override
  Widget build(BuildContext context) => GetBuilder<CategoryController>(
        id: updateId,
        builder: (controller) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    controller.onCollectionTap(null);
                  },
                  icon: const Icon(Icons.close),
                ),
                AppButton.small(
                  onTap: () {
                    Get.dialog(
                      const DialogWrapper(
                        child: SelectProductDialog(),
                      ),
                    );
                  },
                  label: 'Add Products',
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
                  children: [
                    Text(
                      'Collection: ${collection.name} Products',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.collectionProducts.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('No products in this collection'),
                            const SizedBox(height: 16),
                            AppButton.small(
                              onTap: () {
                                Get.dialog(
                                  const DialogWrapper(
                                    child: SelectProductDialog(),
                                  ),
                                );
                              },
                              label: 'Add Products',
                              backgroundColor: AppColors.background,
                              borderColor: AppColors.primary,
                              foregroundColor: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      GridView.builder(
                        itemCount: controller.collectionProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.9,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemBuilder: (_, index) {
                          final product = controller.collectionProducts[index];

                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.background,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        if (product.productImages.isNotEmpty) ...[
                                          Positioned.fill(
                                            child: AppImage(
                                              key: Key('product_image_${product.id}'),
                                              product.productImages.first,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ] else if (product.canvasImage.isNotEmpty) ...[
                                          Positioned.fill(
                                            child: AppImage(
                                              key: Key('product_image_${product.id}'),
                                              product.canvasImage,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: AppButton.small(
                                            onTap: () {
                                              controller.onRemoveProductsTap([product.id]);
                                            },
                                            label: 'Remove',
                                            backgroundColor: AppColors.background,
                                            borderColor: AppColors.primary,
                                            foregroundColor: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
