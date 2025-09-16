import 'package:flutter/material.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ProductSwitch extends StatelessWidget {
  const ProductSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: context.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            activeTrackColor: AppColors.primary,
            value: value,
            onChanged: onChanged,
          ),
        ],
      );
}
