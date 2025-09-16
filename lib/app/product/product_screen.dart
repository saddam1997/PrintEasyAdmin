import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
        builder: (controller) => Scaffold(
          floatingActionButton: const FloatingActionButton(
            onPressed: AppRouter.goToAddProduct,
            child: Icon(Icons.add),
          ),
          body: controller.categories.isEmpty
              ? const AppLoader()
              : DefaultTabController(
                  length: controller.productStructure.length,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: context.isMobile ? 0 : 16),
                        isScrollable: context.isMobile,
                        tabAlignment: context.isMobile ? TabAlignment.start : null,
                        dividerHeight: 0,
                        splashBorderRadius: BorderRadius.circular(40),
                        labelColor: AppColors.white,
                        unselectedLabelColor: AppColors.primary,
                        tabs: controller.productStructure.keys
                            .map((e) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Tab(text: e.name),
                                ))
                            .toList(),
                      ),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: controller.productStructure.values
                              .map(
                                (e) => ProductListingScreen(subcategoryStructure: e),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
}
