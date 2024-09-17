import 'package:flutter/material.dart';

class PokemonSearchField extends StatelessWidget
    implements PreferredSizeWidget {
  const PokemonSearchField({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search for a Pokémon by name',
            style: textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w100,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Pokémon name',
              hintStyle: textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w100,
              ),
              prefixIcon: const Icon(Icons.search),
              border: InputBorder.none,
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
