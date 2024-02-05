import 'package:flutter/material.dart';
import 'package:uniform/uniform.dart';

class DropdownInputField<T extends Object> extends StatelessWidget {
  const DropdownInputField({
    required this.tag,
    required this.menuEntries,
    this.hintText,
    super.key,
  });

  final Object tag;
  final List<DropdownMenuEntry<T>> menuEntries;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.labelLarge;

    return InputFieldBuilder<T>(
      tag: tag,
      builder: (context, controller, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return DropdownMenu(
              width: constraints.maxWidth,
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
      },
    );
  }
}
