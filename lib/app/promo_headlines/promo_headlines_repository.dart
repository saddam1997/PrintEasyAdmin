import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

/// 📰 Repository to handle CRUD operations for Promo Headlines.
class PromoHeadlinesRepository {
  /// 📥 Fetch all promo headlines.
  Future<RepoResponse<String>> fetchAllHeadlines() async =>
      await ApiWrapper.makeRequest(
        Endpoints.promoHeadlines,
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  /// 🔍 Fetch a single promo headline by [id].
  Future<RepoResponse<String>> fetchHeadlineById(String id) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.promoHeadlines}/$id',
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  /// ➕ Create a new promo headline with [payload].
  Future<RepoResponse<String>> createHeadline({
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        Endpoints.promoHeadlines,
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  /// 🔁 Update existing promo headline [id] with [payload].
  Future<RepoResponse<String>> updateHeadline({
    required String id,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.promoHeadlines}/$id',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  /// 🗑️ Delete promo headline by [id].
  Future<RepoResponse<String>> deleteHeadline(String id) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.promoHeadlines}/$id',
        requestType: RequestType.delete,
        headers: await AppUtility.headers,
        showDialog: true,
      );
}
