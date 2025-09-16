import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class SubcategoryDropdown extends StatelessWidget {
  const SubcategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<OrdersController>()) {
      OrdersBinding().dependencies();
    }
    return GetBuilder<OrdersController>(
      builder: (controller) => DropDown<CategoryModel>(
        items: controller.categories,
        selectedItemBuilder: (_) => controller.categories
            .map(
              (e) => Text(
                e.name,
              ),
            )
            .toList(),
        itemBuilder: (_, model) => Text(
          model.name,
        ),
        onChanged: controller.onSubcategoryChanged,
        value: controller.selectedCategory,
      ),
    );
  }
}
