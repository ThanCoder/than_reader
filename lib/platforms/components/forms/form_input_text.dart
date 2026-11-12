import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class FormInputText extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    this.inputTextProps = const FormInputTextProps(),
    this.validator,
  });
  final TextEditingController controller;
  final FormInputTextProps inputTextProps;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  ///
  /// The returned value is exposed by the [FormFieldState.errorText] property.
  /// The [TextFormField] uses this to override the [InputDecoration.errorText]
  /// value.
  final String? Function(String? val)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: inputTextProps.maxLines,
      decoration: InputDecoration(
        label: inputTextProps.label,
        border: OutlineInputBorder(borderRadius: .circular(6)),
        errorText: inputTextProps.errorText,
      ),
      inputFormatters: inputTextProps.inputFormatters,
      keyboardType: inputTextProps.keyboardType,
      onChanged: inputTextProps.onChanged,
      validator: validator,
    );
  }
}

class FormInputTextProps {
  final int? maxLines;
  final Widget? label;
  final String? errorText;
  final void Function(String val)? onChanged;
  final void Function(String val)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const FormInputTextProps({
    this.maxLines,
    this.label,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.keyboardType,
  });
}
