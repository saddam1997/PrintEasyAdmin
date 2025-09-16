import 'package:flutter/material.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

List<Widget> getActions(NavItem item) => switch (item) {
      NavItem.orders => [
          const ResponsiveBuilder(
            mobile: SizedBox.shrink(),
            desktop: IntrinsicWidth(
              child: SubcategoryDropdown(),
            ),
          ),
          const SizedBox(width: 8),
          const AppRefreshButton(),
          const SizedBox(width: 8),
        ],
      _ => [],

      // NavItem.upload => [
      //     const ResponsiveBuilder(
      //       mobile: SizedBox.shrink(),
      //       desktop: IntrinsicWidth(
      //         child: SubcategoryDropdown(),
      //       ),
      //     ),
      //     const SizedBox(width: 8),
      //   ],
    };

Widget? getBottom(NavItem item) => switch (item) {
      NavItem.orders => const SubcategoryDropdown(),
      _ => null,
      // NavItem.upload => null,
    };
