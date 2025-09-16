class Endpoints {
  const Endpoints._();

  static const String baseUrl = 'https://api.onrise.in';
  // static const String baseUrl = 'https://print-easy-backend.vercel.app';
  // static const String baseUrl = 'http://localhost:3000';

  static const String getAddress = 'https://api.postalpincode.in/pincode/';

  static const String createShipment = '/softdata';

  static const String getPlaceFromLatLng = 'https://us-central1-printeasy-68c61.cloudfunctions.net/getPlaceFromLatLng';

  static const String addressAutoComplete = 'https://us-central1-printeasy-68c61.cloudfunctions.net/getAutocompletePredictions';

  static const String getAddressDetails = 'https://us-central1-printeasy-68c61.cloudfunctions.net/getPlaceDetails';

  static const String orders = '/v1/orders/all';

  static const String categories = '/v1/categories';

  static const String categoriesList = '$categories/list';

  static const String allCategories = '$categories/all';

  static const String categoriesBanner = '$categories/banners';

  static const String categoriesDetails = '$categories/details';

  static const String product = '/v2/product';

  static const String allProducts = '$product/all';

  static const String productByCategory = '$product/category';

  static const String banner = '/v2/banner';

  static const String franchises = '/v2/franchise';

  static const String commission = '/v2/commission';

  static const String subcategories = 'subcategories';

  static const String configurations = 'configurations';

  static const String illustrations = 'illustrations';

  static const String collections = 'collections';

  static const String giftRewards = '/v2/giftreward';

  static const String promoHeadlines = '/v2/promo-headline';

}
