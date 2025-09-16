import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class FontOptions extends StatelessWidget {
  const FontOptions({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 80,
        child: GetBuilder<ProductController>(
          builder: (controller) => ListView.separated(
            itemCount: PrintEasyFonts.values.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, index) {
              final font = PrintEasyFonts.values[index];
              final isSelected = controller.selectedFont == font;
              return TapHandler(
                onTap: () {
                  controller.onChangeFont(font);
                },
                radius: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                      width: isSelected ? 2 : 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    font.family,
                    style: TextStyle(
                      fontFamily: font.family,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.accent : Colors.black,
                      package: 'printeasy_utils',
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
