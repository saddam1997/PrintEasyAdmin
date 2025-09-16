import 'package:flutter/material.dart';

enum NavItem {
  categories(
    'Categories',
    Icons.category_outlined,
    Icons.category_rounded,
  ),
  orders(
    'Orders',
    Icons.local_mall_outlined,
    Icons.local_mall_rounded,
  ),
  products(
    'Products',
    Icons.inventory_2_outlined,
    Icons.inventory_2_rounded,
  ),
  banners(
    'Banners',
    Icons.ad_units_outlined,
    Icons.ad_units_rounded,
  ),
  franchises(
    'Franchises',
    Icons.storefront_outlined,
    Icons.storefront_rounded,
  ),
  promoHeadlines(
    'Promo Headlines',
    Icons.campaign_outlined,
    Icons.campaign_rounded,
  ),
  giftRewards(
    'Gift Rewards',
    Icons.card_giftcard_outlined,
    Icons.card_giftcard_rounded,
  );

  factory NavItem.fromPath(String path) => NavItem.values.firstWhere(
        (e) => e.name == path,
        orElse: () => NavItem.values.first,
      );

  const NavItem(
    this.label,
    this.icon,
    this.selectedIcon,
  );

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
