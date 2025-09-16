import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/app/gifts_rewards/gift_rewards_bindings.dart';
import 'package:printeasy_admin/app/gifts_rewards/screens/add_gift_rewards_screen.dart';
import 'package:printeasy_admin/app/gifts_rewards/screens/gifts_rewards_screen.dart';
import 'package:printeasy_admin/app/promo_headlines/promo_headlines_bindings.dart';
import 'package:printeasy_admin/app/promo_headlines/screens/add_promo_headline_screen.dart';
import 'package:printeasy_admin/app/promo_headlines/screens/promo_headlines_screen.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

part 'routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static const _transitionDuration = Duration(milliseconds: 500);

  static GetPage<dynamic> get unknownRoute => GetPage<DashboardScreen>(
        name: DashboardScreen.route,
        page: DashboardScreen.new,
        middlewares: [
          StrictAuthMiddleware(),
        ],
        bindings: [
          DashboardBinding(),
        ],
        transitionDuration: _transitionDuration,
      );

  static final pages = <GetPage>[
    GetPage<SplashScreen>(
      name: SplashScreen.route,
      page: SplashScreen.new,
      binding: SplashBinding(),
      transitionDuration: _transitionDuration,
    ),
    GetPage<AuthScreen>(
      name: AuthScreen.route,
      page: AuthScreen.new,
      bindings: [
        AuthBinding(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<DashboardScreen>(
      name: DashboardScreen.route,
      page: DashboardScreen.new,
      middlewares: [
        StrictAuthMiddleware(),
      ],
      bindings: [
        DashboardBinding(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<AddProductScreen>(
      name: AddProductScreen.route,
      page: () {
        final data = Get.arguments?['product'] as Map<String, dynamic>?;
        return AddProductScreen(
          product: data != null ? ProductModel.fromMap(data) : null,
        );
      },
      bindings: [
        ProductBinding(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<AddFranchiseScreen>(
      name: AddFranchiseScreen.route,
      page: () {
        final data = Get.arguments?['franchise'] as Map<String, dynamic>?;
        return AddFranchiseScreen(
          franchise: data != null ? FranchiseModel.fromMap(data) : null,
        );
      },
      bindings: [
        FranchiseBinding(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<SearchAddressView>(
      name: SearchAddressView.route,
      page: SearchAddressView.new,
      bindings: [
        FranchiseBinding(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<GiftsRewardsScreen>(
      name: GiftsRewardsScreen.route,
      page: GiftsRewardsScreen.new,
      middlewares: [
        StrictAuthMiddleware(),
      ],
      bindings: [
        GiftRewardsBindings(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<AddGiftRewardsScreen>(
      name: AddGiftRewardsScreen.route,
      page: () {
        final data = Get.arguments?['giftReward'] as Map<String, dynamic>?;
        return AddGiftRewardsScreen(
          giftRewardModel: data != null ? GiftRewardModel.fromMap(data) : null,
        );
      },
      middlewares: [
        StrictAuthMiddleware(),
      ],
      bindings: [
        GiftRewardsBindings(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<PromoHeadlinesScreen>(
      name: PromoHeadlinesScreen.route,
      page: PromoHeadlinesScreen.new,
      middlewares: [
        StrictAuthMiddleware(),
      ],
      bindings: [
        PromoHeadlinesBindings(),
      ],
      transitionDuration: _transitionDuration,
    ),
    GetPage<AddPromoHeadlineScreen>(
      name: AddPromoHeadlineScreen.route,
      page: () {
        final data =
            Get.arguments?['promoHeadline'] as Map<String, dynamic>?;
        return AddPromoHeadlineScreen(
          promoHeadlineModel:
              data != null ? PromoHeadlineModel.fromMap(data) : null,
        );
      },
      middlewares: [
        StrictAuthMiddleware(),
      ],
      bindings: [
        GiftRewardsBindings(),
      ],
      transitionDuration: _transitionDuration,
    ),
  ];
}
