import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class FontSizeOptions extends StatelessWidget {
  const FontSizeOptions({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        child: GetBuilder<ProductController>(
          builder: (controller) => ListView.separated(
            itemCount: 20,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final fontSize = index * 2 + 10;
              final isSelected = controller.selectedFontSize == fontSize;
              return TapHandler(
                onTap: () {
                  controller.onChangeFontSize(fontSize.toDouble());
                },
                radius: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                      width: isSelected ? 2 : 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$fontSize',
                    style: context.titleMedium?.copyWith(
                      color: isSelected ? AppColors.accent : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
