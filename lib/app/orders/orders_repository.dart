import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class OrdersRepository {
  Future<RepoResponse<String>> getAllOrders(
    Map<String, dynamic> payload,
  ) async =>
      await ApiWrapper.makeRequest(
        '${Endpoints.orders}?${payload.makeQuery()}',
        requestType: RequestType.get,
        headers: await AppUtility.headers,
      );
}
