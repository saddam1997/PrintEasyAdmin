import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class FranchiseRepository {
  Future<RepoResponse<String>> getAllFranchises() async => await ApiWrapper.makeRequest(
        Endpoints.franchises,
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );

  Future<RepoResponse<String>> getPredictions(
    String query,
  ) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.addressAutoComplete}?input=$query',
        baseUrl: '',
        requestType: RequestType.get,
        headers: {},
      );

  Future<RepoResponse<String>> getAddressDetails(
    String placeId,
  ) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.getAddressDetails}?place_id=$placeId',
        baseUrl: '',
        requestType: RequestType.get,
        headers: {},
        showLoader: true,
      );

  Future<RepoResponse<String>> createFranchise(
    Map<String, dynamic> data,
  ) async =>
      await ApiWrapper.makeRequest(
        Endpoints.franchises,
        requestType: RequestType.post,
        headers: await AppUtility.headers,
        payload: data.removeNullValues(),
        showLoader: true,
      );

  Future<RepoResponse<String>> updateFranchise({
    required String id,
    required Map<String, dynamic> data,
  }) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.franchises}/$id',
        requestType: RequestType.patch,
        headers: await AppUtility.headers,
        payload: data.removeNullValues(),
        showLoader: true,
      );
}
