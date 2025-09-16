import 'package:flutter/material.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class NavRailItem extends StatelessWidget {
  const NavRailItem(
    this.item, {
    super.key,
    this.isSelected = false,
    this.onTap,
    this.label,
    this.leading,
    this.trailing,
  });

  final NavItem item;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? leading;
  final String? label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 160,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 4),
          child: ListTile(
            onTap: () => onTap?.call(),
            shape: const StadiumBorder(),
            tileColor: isSelected ? AppColors.onPrimary : null,
            leading: leading ??
                (isSelected
                    ? Icon(
                        item.selectedIcon,
                        color: AppColors.primary,
                      )
                    : Icon(
                        item.icon,
                        color: AppColors.black,
                      )),
            trailing: trailing,
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(
              label ?? item.label,
              style: context.labelMedium?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.black,
                fontWeight: isSelected ? FontWeight.w700 : null,
              ),
            ),
          ),
        ),
      );
}
