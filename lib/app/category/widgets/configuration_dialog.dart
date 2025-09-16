import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printeasy_admin/app/app.dart';
import 'package:printeasy_utils/printeasy_utils.dart';

class ConfigurationDialog extends StatefulWidget {
  const ConfigurationDialog(
    this.configuration, {
    super.key,
    this.isNew = false,
  });

  final OptionsModel configuration;
  final bool isNew;

  @override
  State<ConfigurationDialog> createState() => _ConfigurationDialogState();
}

class _ConfigurationDialogState extends State<ConfigurationDialog> {
  final TextEditingController _labelController = TextEditingController();
  var optionControllers = <TextEditingController>[];

  List<String> get options => widget.configuration.options.map((e) => e.text).toList();

  bool isNewOption(String option) => !options.contains(option);

  String get inputLabel => widget.isNew ? 'Option' : widget.configuration.text;

  final _formKey = GlobalKey<FormState>();

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _labelController.text = widget.configuration.text;
    optionControllers = widget.configuration.options
        .map(
          (e) => TextEditingController(text: e.text),
        )
        .toList();
    if (widget.isNew) {
      optionControllers.add(TextEditingController());
    }
  }

  Future<void> onSaveTap() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final newOptions = optionControllers
        .map((e) => e.text)
        .where(
          (e) => isNewOption(e) && e.trim().isNotEmpty,
        )
        .toList();

    if (_labelController.text.trim() == widget.configuration.text && newOptions.isEmpty) {
      Get.back();
      return;
    }

    final configuration = widget.configuration.copyWith(
      label: _labelController.text.trim(),
    );

    final didUpdated = await Get.find<CategoryController>().onSaveConfiguration(
      configuration: configuration,
      options: newOptions,
      isNew: widget.isNew,
    );
    if (didUpdated) {
      Get.back();
    }
  }

  void addOption() {
    optionControllers.add(TextEditingController());
    setState(() {});
    Utility.updateLater(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> onRemoveOption({
    required String option,
    required int index,
  }) async {
    if (isNewOption(option)) {
      optionControllers.removeAt(index);
      setState(() {});
      return;
    }
    final didDeleted = await Get.find<CategoryController>().onRemoveConfigurationOption(
      widget.configuration,
      widget.configuration.options.firstWhere((e) => e.text == option).value,
    );
    if (didDeleted) {
      widget.configuration.options.removeAt(index);
      // widget.configuration.options.removeWhere((e) => e.text == option);
      optionControllers.removeAt(index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              Text(
                widget.isNew ? 'New Configuration' : 'Configuration: ${widget.configuration.text}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InputField(
                controller: _labelController,
                label: 'Configuration Name',
                hintText: 'Configuration Name',
                validator: AppValidators.userName,
              ),
              const Text(
                'Options',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    spacing: 16,
                    children: [
                      ...optionControllers.indexed.map(
                        (e) {
                          final i = e.$1;
                          final tec = e.$2;
                          return InputField(
                            controller: tec,
                            label: '$inputLabel ${i + 1}',
                            validator: AppValidators.userName,
                            suffixIcon: i == 0
                                ? null
                                : IconButton(
                                    onPressed: () => onRemoveOption(
                                      option: tec.text,
                                      index: i,
                                    ),
                                    icon: const Icon(Icons.close),
                                  ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              AppButton.small(
                onTap: addOption,
                label: 'Add Option',
                backgroundColor: AppColors.background,
                borderColor: AppColors.primary,
                foregroundColor: AppColors.primary,
              ),
              const SizedBox(height: 4),
              AppButton(
                onTap: onSaveTap,
                label: widget.isNew ? 'Add Configuration' : 'Save Configuration',
              ),
            ],
          ),
        ),
      );
}
