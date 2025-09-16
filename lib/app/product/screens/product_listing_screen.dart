import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ProductListingScreen extends StatelessWidget {
  const ProductListingScreen({
    super.key,
    required this.subcategoryStructure,
  });

  final SubcategoryStructure subcategoryStructure;

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) => Scaffold(
          body: subcategoryStructure.isEmpty
              ? const Center(
                  child: Text('No Subcategory found'),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final subcategory = subcategoryStructure.keys.elementAt(index);
                            final products = subcategoryStructure[subcategory];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    subcategory.name,
                                    style: context.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ProductGrid(
                                  products: products ?? [],
                                  onTap: (product) {
                                    AppRouter.goToAddProduct(product);
                                  },
                                ),
                              ],
                            );
                          },
                          childCount: subcategoryStructure.length,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    required this.products,
    this.onTap,
  });

  final List<ProductModel> products;
  final Function(ProductModel)? onTap;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found'));
    }
    final crossAxisCount = switch (context.type) {
      LayoutType.mobileSmall => 1,
      LayoutType.mobile => 2,
      LayoutType.tablet => 3,
      LayoutType.desktop => 3,
      LayoutType.desktopLarge => 4,
    };
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return TapHandler(
          key: Key('product_${product.id}'),
          onTap: () => onTap?.call(product),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: context.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'SKU: ${product.sku}',
                                    style: context.bodySmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        '₹${product.totalPrice}',
                                        style: context.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (product.discountedPrice > 0)
                                        Text(
                                          '₹${product.basePrice}',
                                          style: context.bodySmall?.copyWith(
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final data = product.copyWith(
                                      id: '',
                                      canvasImage: '',
                                      illustrationImage: '',
                                      productImages: [],
                                      sku: '',
                                      slug: '',
                                    );
                                    AppRouter.goToAddProduct(data);
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                Text(
                                  product.isActive ? 'Active' : 'Inactive',
                                  style: context.bodyMedium?.copyWith(
                                    color: product.isActive ? AppColors.accent : AppColors.error,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 32,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      scrollDirection: Axis.horizontal,
                      children: [
                        if (product.isFeatured) ...[
                          const _ProductLabel(
                            label: 'Featured',
                            color: AppColors.error,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (product.isBestSeller) ...[
                          const _ProductLabel(
                            label: 'Best Seller',
                            color: AppColors.accent,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (product.isNewArrival) ...[
                          const _ProductLabel(
                            label: 'New Arrival',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (product.isTopChoice) ...[
                          const _ProductLabel(
                            label: 'Top Choice',
                            color: AppColors.secondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductLabel extends StatelessWidget {
  const _ProductLabel({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: context.labelSmall?.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      );
}
