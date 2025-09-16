import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class SelectProductDialog extends StatefulWidget {
  const SelectProductDialog({super.key});

  @override
  State<SelectProductDialog> createState() => _SelectProductDialogState();
}

class _SelectProductDialogState extends State<SelectProductDialog> {
  var selectedIds = <String>[];
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Get.find<CategoryController>().getProductsByCategory();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= (_scrollController.position.maxScrollExtent * 0.8)) {
      Get.find<CategoryController>().getProductsByCategory(forPagination: true);
    }
  }

  void _onProductTap(ProductModel product) {
    if (selectedIds.contains(product.id)) {
      selectedIds.remove(product.id);
    } else {
      selectedIds.add(product.id);
    }
    setState(() {});
  }

  void _onAddProductsTap() async {
    await Get.find<CategoryController>().onAddProductsTap(selectedIds);
    Get.back();
  }

  @override
  Widget build(BuildContext context) => GetBuilder<CategoryController>(
        id: CategoryScreen.updateId,
        builder: (controller) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Select Products'),
                IconButton(
                  onPressed: Get.back,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Expanded(
              child: controller.fetchingProducts
                  ? const AppLoader()
                  : controller.categoryProducts.isEmpty
                      ? const Center(
                          child: Text('No products found'),
                        )
                      : GridView.builder(
                          controller: _scrollController,
                          itemCount: controller.categoryProducts.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                          ),
                          itemBuilder: (_, index) {
                            final product = controller.categoryProducts[index];
                            final isSelected = selectedIds.contains(product.id);
                            return TapHandler(
                              onTap: () {
                                _onProductTap(product);
                              },
                              radius: 8,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.background,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    children: [
                                      if (product.productImages.isNotEmpty) ...[
                                        Expanded(
                                          child: AppImage(
                                            key: Key('product_image_${product.id}'),
                                            product.productImages.first,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ] else if (product.canvasImage.isNotEmpty) ...[
                                        Expanded(
                                          child: AppImage(
                                            key: Key('product_image_${product.id}'),
                                            product.canvasImage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            AppButton(
              onTap: _onAddProductsTap,
              label: 'Add Products',
            ),
          ],
        ),
      );
}
