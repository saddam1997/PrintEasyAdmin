import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class SelectIllustrationDialog extends StatefulWidget {
  const SelectIllustrationDialog({super.key, required this.illustrations});

  final List<IllustrationModel> illustrations;

  @override
  State<SelectIllustrationDialog> createState() => _SelectIllustrationDialogState();
}

class _SelectIllustrationDialogState extends State<SelectIllustrationDialog> {
  var selectedIllustration = '';

  @override
  void initState() {
    super.initState();
    selectedIllustration = Get.find<ProductController>().selectedIllustration;
  }

  @override
  Widget build(BuildContext context) => GetBuilder<ProductController>(
      builder: (controller) => Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              const Text(
                'Select Illustration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: GridView.builder(
                  itemCount: widget.illustrations.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (_, index) {
                    final illustration = widget.illustrations[index];
                    final isSelected = illustration.id == selectedIllustration;
                    return TapHandler(
                      radius: 8,
                      onTap: () {
                        setState(() {
                          selectedIllustration = illustration.id;
                        });
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: AppImage(
                            widget.illustrations[index].imageUrl,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppButton(
                onTap: selectedIllustration.isEmpty
                    ? null
                    : () {
                        controller.selectedIllustration = controller.illustrations.firstWhere((e) => e.id == selectedIllustration).imageUrl;
                        Get.back();
                      },
                label: 'Select',
              ),
            ],
          ));
}
