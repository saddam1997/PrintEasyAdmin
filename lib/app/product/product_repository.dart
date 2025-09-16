import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ProductRepository {
  Future<RepoResponse<String>> getAllCategories() async => await ApiWrapper.makeRequest(
        Endpoints.categoriesDetails,
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  Future<RepoResponse<String>> getAllProducts() async => await ApiWrapper.makeRequest(
        Endpoints.allProducts,
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  Future<RepoResponse<String>> getProductsByCategory({
    required String categoryId,
    Map<String, dynamic> query = const {},
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.productByCategory}/$categoryId?${query.makeQuery()}',
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  Future<RepoResponse<String>> getProductsByCollection({
    Map<String, dynamic> payload = const {},
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.product}/${Endpoints.collections}?${payload.makeQuery()}',
        requestType: RequestType.get,
        headers: await AppUtility.headers,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> createProduct({
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        Endpoints.product,
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> updateProduct({
    required String id,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.product}/$id',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> addProductsToCollection({
    required String categoryId,
    required String collectionId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.collections}/$collectionId/products/add',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> removeProductFromCollection({
    required String categoryId,
    required String collectionId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.collections}/$collectionId/products/remove',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );
}
