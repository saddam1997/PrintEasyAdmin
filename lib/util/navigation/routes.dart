part of 'pages.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';

  static const String auth = '/auth';

  static const String dashboard = '/dashboard';

  static const String support = '/support';

  static const String products = '/products';
  static const String addProduct = '$products/add';

  static const String orders = '/orders';
  static const String _orderDetails = '/details';
  static const String orderDetails = '$orders$_orderDetails';

  static const String franchise = '/franchise';
  static const String addFranchise = '$franchise/add';

  static const String searchAddress = '/address/search';

  static const String giftRewards = '/giftRewards';
  static const String addGiftReward = '$giftRewards/add';

  static const String promoHeadlines = '/promoHeadlines';
  static const String addPromoHeadline = '$promoHeadlines/add';
}
