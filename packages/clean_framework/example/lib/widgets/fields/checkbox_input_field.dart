import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class CheckboxInputField extends StatelessWidget {
  const CheckboxInputField({
    required this.tag,
    required this.label,
    super.key,
  });

  final Object tag;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InputFieldBuilder<bool>(
      tag: tag,
      initialValue: false,
      builder: (context, controller, _) {
        return CheckboxListTile(
          value: controller.value,
          enabled: !controller.isSubmitted,
          onChanged: controller.onChanged,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(label),
        );
      },
    );
  }
}
