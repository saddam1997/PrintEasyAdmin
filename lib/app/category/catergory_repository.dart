import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class CategoryRepository {
  Future<RepoResponse<String>> createCategory({
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        Endpoints.categories,
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> updateCategory({
    required String categoryId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
      );

  Future<RepoResponse<String>> updateCategoryOrder({
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/order',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
      );

  Future<RepoResponse<String>> createSubcategory({
    required String categoryId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.subcategories}',
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> updateSubcategory({
    required String categoryId,
    required String subcategoryId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.subcategories}/$subcategoryId',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> createConfiguration({
    required String categoryId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.configurations}',
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> updateConfiguration({
    required String categoryId,
    required String configurationId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.configurations}/$configurationId',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
      );

  Future<RepoResponse<String>> deleteConfigurationOption({
    required String categoryId,
    required String configurationId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.configurations}/$configurationId/option',
        requestType: RequestType.delete,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> addIllustration({
    required String categoryId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.illustrations}',
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showDialog: true,
      );

  Future<RepoResponse<String>> createCollection({
    required String categoryId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.collections}',
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> updateCollection({
    required String categoryId,
    required String collectionId,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.categories}/$categoryId/${Endpoints.collections}/$collectionId',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );
}
