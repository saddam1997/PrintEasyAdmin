import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

/// Repository responsible for performing CRUD operations
/// on Gift Rewards via API.
class GiftRewardRepository {
  /// 📦 Fetch all gift rewards from the backend.
  /// - Method: GET
  /// - Endpoint: /giftreward
  Future<RepoResponse<String>> fetchAllRewards() async =>
      await ApiWrapper.makeRequest(
        Endpoints.giftRewards,
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  /// 🔍 Fetch a single gift reward by [id].
  /// - Method: GET
  /// - Endpoint: /giftreward/{id}
  Future<RepoResponse<String>> fetchRewardById(String id) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.giftRewards}/$id',
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  /// ➕ Create a new gift reward with given [payload].
  /// - Method: POST
  /// - Endpoint: /giftreward
  /// - Shows loader and success/error dialog
  Future<RepoResponse<String>> createReward({
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        Endpoints.giftRewards,
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  /// 🛠️ Update an existing gift reward by [id] with new [payload].
  /// - Method: PATCH
  /// - Endpoint: /giftreward/{id}
  /// - Shows loader and success/error dialog
  Future<RepoResponse<String>> updateReward({
    required String id,
    required Map<String, dynamic> payload,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.giftRewards}/$id',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: payload,
        showLoader: true,
        showDialog: true,
      );

  /// ❌ Delete a gift reward by [id].
  /// - Method: DELETE
  /// - Endpoint: /giftreward/{id}
  /// - Shows confirmation dialog
  Future<RepoResponse<String>> deleteReward(String id) async =>
      await ApiWrapper.makeRequest('${Endpoints.giftRewards}/$id',
          requestType: RequestType.delete,
          headers: await AppUtility.headers,
          showDialog: true,
          // payload: {}
      );
}
