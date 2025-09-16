import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const String route = AppRoutes.dashboard;

  @override
  Widget build(BuildContext context) => GetBuilder<DashboardController>(
        builder: (controller) => Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            title: Obx(() => Text(controller.selectedItem.label)),
            centerTitle: true,
            leadingWidth: context.isDesktop ? 200 : 120,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Hero(
                key: ValueKey('AppLogo'),
                tag: 'app-logo',
                child: AppLogo(
                  fit: BoxFit.contain,
                  width: 160,
                ),
              ),
            ),
            actions: getActions(controller.selectedItem),
            bottom: !context.isDesktop && getBottom(controller.selectedItem) != null
                ? PreferredSize(
                    preferredSize: Size(context.width, 64),
                    child: getBottom(controller.selectedItem)!,
                  )
                : null,
          ),
          body: Row(
            children: [
              ResponsiveBuilder(
                mobile: const SizedBox.shrink(),
                desktop: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16).copyWith(
                    right: 16,
                  ),
                  child: Obx(
                    () => Column(
                      children: [
                        ...NavItem.values.indexed.map(
                          (e) => NavRailItem(
                            e.$2,
                            isSelected: controller.selectedItem == e.$2,
                            onTap: () => controller.onNavTap(e.$2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () => controller.selectedItem.screen,
                ),
              ),
            ],
          ),
          bottomNavigationBar: ResponsiveBuilder(
            mobile: NavItem.values.length < 2
                ? const SizedBox.shrink()
                : BottomNavigationBar(
                    elevation: 0,
                    items: NavItem.values
                        .map(
                          (e) => BottomNavigationBarItem(
                            icon: Icon(e.icon),
                            activeIcon: Icon(e.selectedIcon),
                            label: e.label,
                          ),
                        )
                        .toList(),
                    type: BottomNavigationBarType.fixed,
                    currentIndex: NavItem.values.indexOf(controller.selectedItem),
                    selectedItemColor: AppColors.primary,
                    onTap: (index) => controller.onNavTap(NavItem.values[index]),
                  ),
            desktop: const SizedBox.shrink(),
          ),
        ),
      );
}
