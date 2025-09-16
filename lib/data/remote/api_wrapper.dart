import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/data/data.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

/// API WRAPPER to call all the IsmCallApis and handle the status codes
class ApiWrapper {
  const ApiWrapper._();

  /// Method to make all the requests inside the app like GET, POST, PUT, Delete
  static Future<RepoResponse<String>> makeRequest(
    String api, {
    String? baseUrl,
    required RequestType requestType,
    dynamic payload,
    required Map<String, String> headers,
    bool showLoader = false,
    bool showDialog = true,
    String? message,
    bool shouldEncode = true,
  }) async {
    try {
      final baseUrl0 = baseUrl ?? Endpoints.baseUrl;
      final uri = Uri.parse(baseUrl0 + api);

      if (kDebugMode) {
        print('[Request] - $uri\n$headers\n$payload');
      }

      if (showLoader) Utility.showLoader(message);
      // Handles API call
      var start = DateTime.now();
      var response = await _handleRequest(
        uri,
        payload: payload != null
            ? (shouldEncode ? jsonEncode(payload) : payload)
            : null,
        headers: headers,
        requestType: requestType,
      );

      // Handles response based on status code
      var res = await _processResponse(
        response,
        showDialog: showDialog,
        startTime: start,
      );

      if (showLoader) {
        Utility.closeLoader();
      }

      return res;
    } catch (e, st) {
      debugPrint(e.toString());
      debugPrint(st.toString());
      return RepoResponse(
        message: e.toString(),
        hasError: true,
        data: st.toString(),
      );
    }
  }

  static Future<http.Response> _handleRequest(
    Uri api, {
    required RequestType requestType,
    dynamic payload,
    required Map<String, String> headers,
  }) =>
      switch (requestType) {
        RequestType.get => _get(api, headers: headers),
        RequestType.post => _post(api, headers: headers, payload: payload),
        // RequestType.put => throw UnimplementedError(),
        RequestType.patch => _patch(api, headers: headers, payload: payload),
        RequestType.delete => _delete(api, headers: headers, payload: payload),
        // RequestType.upload => throw UnimplementedError(),
      };

  static Future<http.Response> _get(
    Uri api, {
    required Map<String, String> headers,
  }) =>
      http
          .get(
            api,
            headers: headers,
          )
          .timeout(PrintEasyConstants.timeOutDuration);

  static Future<http.Response> _post(
    Uri api, {
    required dynamic payload,
    required Map<String, String> headers,
  }) =>
      http
          .post(
            api,
            headers: headers,
            body: payload,
          )
          .timeout(PrintEasyConstants.timeOutDuration);

  static Future<http.Response> _patch(
    Uri api, {
    required dynamic payload,
    required Map<String, String> headers,
  }) =>
      http
          .patch(
            api,
            headers: headers,
            body: payload,
          )
          .timeout(PrintEasyConstants.timeOutDuration);

  static Future<http.Response> _delete(
    Uri api, {
    required Map<String, String> headers,
    dynamic payload,
  }) =>
      http
          .delete(
            api,
            headers: headers,
            body: payload,
          )
          .timeout(PrintEasyConstants.timeOutDuration);

  /// Method to return the API response based upon the status code of the server
  static Future<RepoResponse<String>> _processResponse(
    http.Response response, {
    required bool showDialog,
    required DateTime startTime,
  }) async {
    var diff = DateTime.now().difference(startTime).inMilliseconds / 1000;
    if (kDebugMode) {
      print('[Response] - ${diff}s ${response.statusCode} ${response.request?.url}\n${response.body}');
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
      case 205:
      case 208:
        return RepoResponse<String>(
          data: utf8.decode(response.bodyBytes),
          hasError: false,
          statusCode: response.statusCode,
        );
      case 401:
        unawaited(AuthService.i.logout());
        await Utility.showInfoDialog(
          DialogModel.error('Please login again to continue'),
          onTap: () => AppRouter.goToAuth(true),
        );
        return RepoResponse<String>(
          data: utf8.decode(response.bodyBytes),
          hasError: true,
          statusCode: response.statusCode,
        );
      case >= 400 && < 500:
        final res = RepoResponse<String>(
          data: utf8.decode(response.bodyBytes),
          hasError: true,
          statusCode: response.statusCode,
        );
        await Utility.showInfoDialog(DialogModel.error(jsonDecode(res.data ?? '{}')['message'] ?? ''));
        return res;
      default:
        return RepoResponse<String>(
          data: utf8.decode(response.bodyBytes),
          hasError: true,
          statusCode: response.statusCode,
        );
    }
  }
}
