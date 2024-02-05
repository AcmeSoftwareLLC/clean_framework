import 'package:animations/animations.dart';
import 'package:clean_framework_example_rest/features/form/presentation/form_ui.dart';
import 'package:clean_framework_example_rest/features/home/presentation/home_ui.dart';
import 'package:clean_framework_example_rest/features/profile/presentation/profile_ui.dart';
import 'package:clean_framework_example_rest/routing/routes.dart';
import 'package:clean_framework_router/clean_framework_router.dart';

class PokeRouter extends AppRouter<Routes> {
  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        AppRoute(
          route: Routes.home,
          builder: (_, __) => HomeUI(),
          routes: [
            AppRoute(
              route: Routes.form,
              builder: (_, __) => FormUI(),
            ),
            AppRoute.custom(
              route: Routes.profile,
              builder: (_, state) {
                print(state.location);
                return ProfileUI(
                  pokemonName: state.params['pokemon_name'] ?? '',
                  pokemonImageUrl: state.extra as String,
                );
              },
              transitionsBuilder: (_, animation, secondaryAnimation, child) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                  child: child,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
