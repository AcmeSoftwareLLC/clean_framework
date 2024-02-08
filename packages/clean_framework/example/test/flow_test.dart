import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_external_interface.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_success_response.dart';
import 'package:clean_framework_example_rest/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example_rest/features/home/presentation/home_ui.dart';
import 'package:clean_framework_example_rest/features/profile/external_interface/pokemon_species_gateway.dart';
import 'package:clean_framework_example_rest/features/profile/presentation/profile_ui.dart';
import 'package:clean_framework_example_rest/providers.dart';
import 'package:clean_framework_example_rest/routing.dart';
import 'package:clean_framework_example_rest/widgets/app_scope.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Flow Test', (tester) async {
    final widget = AppScope(
      child: AppProviderScope(
        externalInterfaceProviders: [pokemonExternalInterfaceProvider],
        overrides: [
          pokemonExternalInterfaceProvider.overrideWith(
            PokemonExternalInterfaceFake(),
          ),
        ],
        child: AppRouterScope(
          create: PokeRouter.new,
          builder: (context) {
            return MaterialApp.router(
              routerConfig: context.router.config,
            );
          },
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.byType(HomeUI), findsOneWidget);

    expect(find.text('BULBASAUR'), findsOneWidget);
    expect(find.text('PIKACHU'), findsOneWidget);

    await tester.tap(find.text('BULBASAUR'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileUI), findsOneWidget);
  });
}

class PokemonExternalInterfaceFake extends PokemonExternalInterface {
  @override
  void handleRequest() {
    on<GetPokemonRequest>(
      (request, send) async {
        if (request is PokemonCollectionRequest) {
          send(
            PokemonSuccessResponse(
              data: {
                'results': [
                  {'name': 'bulbasaur'},
                  {'name': 'pikachu'},
                ],
              },
            ),
          );
        }

        if (request is PokemonSpeciesRequest) {
          send(
            PokemonSuccessResponse(
              data: {
                'flavor_text_entries': [
                  {
                    'flavor_text':
                        'It keeps its tail\nraised to monitor\nits surroundings.\fIf you yank its\ntail, it will try\nto bite you.',
                    'language': {
                      'name': 'en',
                      'url': 'https://pokeapi.co/api/v2/language/9/',
                    },
                    'version': {
                      'name': 'yellow',
                      'url': 'https://pokeapi.co/api/v2/version/3/',
                    }
                  },
                  {
                    'flavor_text':
                        'This intelligent\nPOKéMON roasts\nhard BERRIES with\felectricity to\nmake them tender\nenough to eat.',
                    'language': {
                      'name': 'en',
                      'url': 'https://pokeapi.co/api/v2/language/9/',
                    },
                    'version': {
                      'name': 'gold',
                      'url': 'https://pokeapi.co/api/v2/version/4/',
                    }
                  },
                ],
              },
            ),
          );
        }
      },
    );
  }
}
