import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

class InputText extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    this.inputTextProps = const InputTextProps(),
  });
  final TextEditingController controller;
  final InputTextProps inputTextProps;

  @override
  Widget build(BuildContext context) {
    return TextField(
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
      onSubmitted: inputTextProps.onSubmitted,
    );
  }
}

class InputTextProps {
  final int? maxLines;
  final Widget? label;
  final String? errorText;
  final void Function(String val)? onChanged;
  final void Function(String val)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const InputTextProps({
    this.maxLines,
    this.label,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.inputFormatters,
    this.keyboardType,
  });
}
