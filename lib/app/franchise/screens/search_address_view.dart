import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class SearchAddressView extends StatelessWidget {
  const SearchAddressView({super.key});

  static const String route = AppRoutes.searchAddress;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: !context.isDesktop,
          title: const AppLogo(),
        ),
        body: GetBuilder<FranchiseController>(
          builder: (controller) => Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: PrintEasyConstants.maxTabletWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TypeAheadField<PredictionModel>(
                      controller: controller.searchController,
                      onSelected: (value) => controller.selectPrediction(value),
                      itemBuilder: (context, value) => ListTile(
                        title: Text(value.mainText),
                        subtitle: Text(value.secondaryText),
                      ),
                      suggestionsCallback: (value) {
                        if (value.trim().isEmpty) {
                          return null;
                        }
                        return controller.searchAhead(value);
                      },
                      builder: (context, controller, focusNode) => Column(
                        children: [
                          InputField(
                            autofocus: true,
                            prefixIcon: const Icon(Icons.search_rounded),
                            focusNode: focusNode,
                            controller: controller,
                            hintText: 'Search for area, street name',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
