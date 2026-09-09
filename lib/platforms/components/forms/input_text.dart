import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  const new({
    super.key,
    required this.controller,
    this.label,
    this.maxLines,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
  });
  final TextEditingController controller;
  final int? maxLines;
  final Widget? label;
  final String? errorText;
  final void Function(String val)? onChanged;
  final void Function(String val)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        label: label,
        border: OutlineInputBorder(borderRadius: .circular(6)),
        errorText: errorText,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
