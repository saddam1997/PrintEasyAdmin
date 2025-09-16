import 'package:flutter/material.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class IllustrationDialog extends StatelessWidget {
  const IllustrationDialog({
    super.key,
    required this.illustrations,
  });

  final List<IllustrationModel> illustrations;

  @override
  Widget build(BuildContext context) => GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: illustrations.length,
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
      );
}
