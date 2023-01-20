import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework_example/features/home/presentation/home_ui.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@isTest
void uiTest<V extends ViewModel>(
  String description, {
  required UI ui,
  required V viewModel,
  required FutureOr<void> Function(WidgetTester) verify,
}) {
  testWidgets(description, (tester) async {
    await tester.pumpWidget(
      AppProviderScope(
        child: MaterialApp(
          home: ViewModelScope(
            child: ui,
            viewModel: viewModel,
          ),
        ),
      ),
    );

    await verify(tester);
  });
}

void main() {
  group('HomeUI tests |', () {
    uiTest(
      '',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        pokemons: [
          PokemonModel(name: 'Pikachu', imageUrl: ''),
          PokemonModel(name: 'Bulbasaur', imageUrl: ''),
        ],
        isLoading: false,
        hasFailedLoading: false,
        lastViewedPokemon: '',
        onRetry: () {},
        onRefresh: () async {},
        onSearch: (query) {},
      ),
      verify: (tester) async {
        expect(find.text('Pikachu'), findsOneWidget);
        expect(find.text('Bulbasaur'), findsOneWidget);
      },
    );
  });
}
