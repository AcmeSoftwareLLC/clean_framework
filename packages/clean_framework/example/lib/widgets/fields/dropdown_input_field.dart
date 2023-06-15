import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class DropdownInputField<T extends Object> extends StatelessWidget {
  const DropdownInputField({
    required this.tag,
    required this.menuEntries,
    this.hintText,
    this.width,
    super.key,
  });

  final Object tag;
  final List<DropdownMenuEntry<T>> menuEntries;
  final String? hintText;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelLarge;

    return InputFieldBuilder<T>(
      tag: tag,
      builder: (context, controller, _) {
        return DropdownMenu(
          width: width,
          requestFocusOnTap: false,
          enabled: !controller.isSubmitted,
          errorText: controller.error.message,
          hintText: hintText,
          textStyle: controller.isSubmitted
              ? textStyle?.copyWith(color: theme.disabledColor)
              : textStyle,
          initialSelection: controller.value,
          dropdownMenuEntries: menuEntries,
          onSelected: controller.onChanged,
        );
      },
    );
  }
}
