import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ColorOptions extends StatelessWidget {
  const ColorOptions({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        child: GetBuilder<ProductController>(
          builder: (controller) => ListView.separated(
            itemCount: PrintEasyColors.values.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final color = PrintEasyColors.values[index];
              final isSelected = controller.selectedColor == color;
              return TapHandler(
                onTap: () {
                  controller.onChangeColor(color);
                },
                radius: 0,
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    color: color.color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.grey,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
