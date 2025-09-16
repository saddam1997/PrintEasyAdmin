import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_admin/util/utils.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class AddFranchiseScreen extends StatelessWidget {
  const AddFranchiseScreen({
    super.key,
    this.franchise,
  });

  final FranchiseModel? franchise;

  static const String route = AppRoutes.addFranchise;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(franchise?.name ?? 'Add Franchise'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GetBuilder<FranchiseController>(
            initState: (_) {
              final controller = Get.find<FranchiseController>();
              controller.initFranchise(franchise);
            },
            builder: (controller) => Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: InputField(
                          controller: controller.nameTEC,
                          label: 'Name',
                          textInputType: TextInputType.name,
                          validator: AppValidators.userName,
                          autofillHints: const [
                            AutofillHints.name,
                            AutofillHints.givenName,
                            AutofillHints.middleName,
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: InputField(
                          controller: controller.mobileTEC,
                          label: 'Mobile Number',
                          prefixText: '+91 | ',
                          maxLength: 10,
                          textInputType: TextInputType.phone,
                          validator: AppValidators.phoneNumber,
                          autofillHints: const [
                            AutofillHints.telephoneNumber,
                          ],
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    controller: controller.emailTEC,
                    textInputType: TextInputType.emailAddress,
                    label: 'Email',
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    controller: controller.couponCodeTEC,
                    readOnly: franchise != null,
                    fillColor: franchise != null ? AppColors.grey.shade100 : null,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                      UpperCaseTextFormatter(),
                    ],
                    label: 'Coupon Code',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: controller.commissionTEC,
                          textInputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          label: 'Commission (in %)',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InputField(
                          controller: controller.discountTEC,
                          textInputType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          label: 'Discount (in %)',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.grey),
                  const SizedBox(height: 8),
                  const InputField(
                    readOnly: true,
                    onTap: AppRouter.goToSearchAddress,
                    prefixIcon: Icon(Icons.search_rounded),
                    borderColor: AppColors.primary,
                    hintText: 'Search your nearest building or location',
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.grey),
                  const SizedBox(height: 8),
                  InputField(
                    label: 'Flat / House no / Floor / Building *',
                    controller: controller.line1TEC,
                    autofillHints: const [
                      AutofillHints.streetAddressLine1,
                      AutofillHints.streetAddressLevel3,
                      AutofillHints.streetAddressLevel4,
                    ],
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'Road name / Area / Colony',
                    controller: controller.line2TEC,
                    autofillHints: const [
                      AutofillHints.streetAddressLine1,
                      AutofillHints.streetAddressLevel3,
                      AutofillHints.streetAddressLevel4,
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        child: InputField(
                          label: 'Pincode',
                          controller: controller.pinCodeTEC,
                          maxLength: 6,
                          textInputType: TextInputType.phone,
                          validator: AppValidators.userName,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          autofillHints: const [
                            AutofillHints.postalCode,
                            AutofillHints.postalAddressExtendedPostalCode,
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        flex: 2,
                        child: InputField(
                          label: 'City',
                          controller: controller.cityTEC,
                          textInputType: TextInputType.streetAddress,
                          validator: AppValidators.userName,
                          autofillHints: const [
                            AutofillHints.addressCity,
                            AutofillHints.addressCityAndState,
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  InputField(
                    label: 'State',
                    controller: controller.stateTEC,
                    autofillHints: const [
                      AutofillHints.addressCityAndState,
                      AutofillHints.addressState,
                      AutofillHints.streetAddressLevel2,
                    ],
                  ),
                  const SizedBox(height: 24),
                  SafeArea(
                    child: AppButton(
                      onTap: () => controller.onCreateFranchise(franchise),
                      label: franchise != null ? 'Update' : 'Add',
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
