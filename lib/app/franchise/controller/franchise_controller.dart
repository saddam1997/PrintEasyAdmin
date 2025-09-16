import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class FranchiseController extends GetxController {
  FranchiseController(this._viewModel);

  final FranchiseViewModel _viewModel;

  final RxBool _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    if (value == isLoading) {
      return;
    }
    _isLoading.value = value;
  }

  final RxList<FranchiseModel> _franchises = <FranchiseModel>[].obs;
  List<FranchiseModel> get franchises => _franchises;
  set franchises(List<FranchiseModel> value) => _franchises.value = value;

  final Rx<FranchiseModel?> _selectedFranchise = Rx<FranchiseModel?>(null);
  FranchiseModel? get selectedFranchise => _selectedFranchise.value;
  set selectedFranchise(FranchiseModel? value) => _selectedFranchise.value = value;

  final formKey = GlobalKey<FormState>();
  final nameTEC = TextEditingController();
  final mobileTEC = TextEditingController();
  final emailTEC = TextEditingController();
  final couponCodeTEC = TextEditingController();
  final commissionTEC = TextEditingController();
  final discountTEC = TextEditingController();

  PlaceDetailModel? selectedPlace;
  final searchController = TextEditingController();

  final line1TEC = TextEditingController();
  final line2TEC = TextEditingController();
  final pinCodeTEC = TextEditingController();
  final cityTEC = TextEditingController();
  final stateTEC = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData([bool showLoader = true]) async {
    if (showLoader) {
      isLoading = true;
    }
    franchises = await _viewModel.getAllFranchises();
    if (showLoader) {
      isLoading = false;
    }
    if (selectedFranchise != null) {
      selectedFranchise = franchises.cast<FranchiseModel?>().firstWhere(
            (e) => e?.id == selectedFranchise!.id,
            orElse: () => selectedFranchise,
          );
    }
  }

  void initFranchise(FranchiseModel? franchise) {
    if (franchise == null) {
      nameTEC.clear();
      mobileTEC.clear();
      emailTEC.clear();
      couponCodeTEC.clear();
      commissionTEC.clear();
      discountTEC.clear();
      line1TEC.clear();
      line2TEC.clear();
      pinCodeTEC.clear();
      cityTEC.clear();
      stateTEC.clear();
      return;
    }
    nameTEC.text = franchise.name;
    mobileTEC.text = franchise.address.mobile;
    emailTEC.text = franchise.address.email;
    couponCodeTEC.text = franchise.couponCode;
    commissionTEC.text = franchise.commission.toString();
    discountTEC.text = franchise.discount.toString();
    line1TEC.text = franchise.address.line1;
    line2TEC.text = franchise.address.line2 ?? '';
    pinCodeTEC.text = franchise.address.pinCode;
    cityTEC.text = franchise.address.city;
    stateTEC.text = franchise.address.state;
  }

  Future<List<PredictionModel>> searchAhead(String input) async {
    if (input.trim().length < 3) {
      return [];
    }
    return _viewModel.getPredictions(input);
  }

  void selectPrediction(PredictionModel prediction) async {
    final placeDetails = await _viewModel.getAddressDetails(prediction.placeId);
    searchController.clear();

    selectPlace(placeDetails: placeDetails);
    Get.back();
  }

  void selectPlace({
    PlaceDetailModel? placeDetails,
  }) {
    selectedPlace = placeDetails;
    if (selectedPlace != null) {
      line1TEC.text = selectedPlace!.building;
      line2TEC.text = selectedPlace!.line1 + selectedPlace!.line2;
      pinCodeTEC.text = selectedPlace!.pincode;
      cityTEC.text = selectedPlace!.city;
      stateTEC.text = selectedPlace!.state;
    }

    update();
  }

  void onCreateFranchise(FranchiseModel? model) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    final address = AddressModel(
      id: '',
      name: nameTEC.text.trim(),
      mobile: mobileTEC.text.trim(),
      email: emailTEC.text.trim(),
      line1: line1TEC.text.trim(),
      line2: line2TEC.text.trim(),
      city: cityTEC.text.trim(),
      state: stateTEC.text.trim(),
      country: 'India',
      pinCode: pinCodeTEC.text.trim(),
    );
    final franchise = FranchiseModel(
      name: nameTEC.text.trim(),
      address: address,
      couponCode: couponCodeTEC.text.trim(),
      commission: double.parse(commissionTEC.text.trim()),
      discount: double.parse(discountTEC.text.trim()),
      createdAt: DateTime.now(),
    );
    var isAdded = false;
    if (model == null) {
      isAdded = await _viewModel.createFranchise(
        franchise,
      );
    } else {
      isAdded = await _viewModel.updateFranchise(
        id: model.id,
        franchise: franchise,
      );
    }
    if (isAdded) {
      fetchData(false);
      Get.back();
    }
  }
}
