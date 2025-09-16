import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class BannerRepository {
  Future<RepoResponse<String>> getAllCategories() async => await ApiWrapper.makeRequest(
        Endpoints.categoriesBanner,
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  Future<RepoResponse<String>> addBanner({
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        Endpoints.banner,
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> getBannerImageByCategory({
    required String categoryId,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.banner}/$categoryId',
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  Future<RepoResponse<String>> updateBannerOrder({
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        Endpoints.banner,
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  Future<RepoResponse<String>> updateBanner({
    required Map<String, dynamic> payload,
    required String bannerId,
    required String categoryId,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.banner}/$categoryId/$bannerId',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );
}
