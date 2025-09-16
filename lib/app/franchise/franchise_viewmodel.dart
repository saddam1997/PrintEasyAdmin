import 'dart:convert';
import 'dart:developer';

import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class FranchiseViewModel {
  FranchiseViewModel(this._repository);

  final FranchiseRepository _repository;

  Future<List<FranchiseModel>> getAllFranchises() async {
    try {
      final res = await _repository.getAllFranchises();
      if (res.hasError) {
        return [];
      }

      return res.bodyList
          .map(
            (e) => FranchiseModel.fromMap(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e, st) {
      log('$e\n$st');
      return [];
    }
  }

  Future<List<PredictionModel>> getPredictions(String query) async {
    final response = await _repository.getPredictions(query);

    if (response.hasError) {
      return [];
    }

    final data = jsonDecode(response.data ?? '{}')['predictions'] as List? ?? [];

    return data.map((e) => PredictionModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<PlaceDetailModel?> getAddressDetails(String placeId) async {
    try {
      final response = await _repository.getAddressDetails(placeId);

      if (response.hasError) {
        return null;
      }

      final data = jsonDecode(response.data ?? '{}')['result'];

      return PlaceDetailModel.fromMap(data);
    } catch (e, st) {
      log('$e\n$st');
      return null;
    }
  }

  Future<bool> createFranchise(FranchiseModel franchise) async {
    try {
      final res = await _repository.createFranchise(franchise.toMap());

      return !res.hasError;
    } catch (e, st) {
      log('$e\n$st');
      return false;
    }
  }

  Future<bool> updateFranchise({
    required String id,
    required FranchiseModel franchise,
  }) async {
    try {
      final res = await _repository.updateFranchise(
        id: id,
        data: franchise.toMap(),
      );

      return !res.hasError;
    } catch (e, st) {
      log('$e\n$st');
      return false;
    }
  }
}
