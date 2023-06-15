import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class DropdownInputField<T extends Object> extends StatelessWidget {
  const DropdownInputField({
    required this.tag,
    required this.items,
    this.hintText,
    super.key,
  });

  final Object tag;
  final List<DropdownMenuItem<T>> items;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return InputFieldBuilder<T>(
      tag: tag,
      builder: (context, controller, _) {
        return DropdownButtonFormField(
          value: controller.value,
          onChanged: controller.onChanged,
          decoration: InputDecoration(
            errorText: controller.error.message,
            hintText: hintText,
          ),
          items: items,
        );
      },
    );
  }
}
