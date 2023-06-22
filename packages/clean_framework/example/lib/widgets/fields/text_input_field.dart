import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    required this.tag,
    required this.hintText,
    this.obscureText = false,
    super.key,
  });

  final Object tag;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextInputFieldBuilder(
      tag: tag,
      builder: (context, controller, textEditingController) {
        return TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: controller.error.message,
          ),
          onChanged: controller.onChanged,
          obscureText: obscureText,
          enabled: !controller.isSubmitted,
        );
      },
    );
  }
}
