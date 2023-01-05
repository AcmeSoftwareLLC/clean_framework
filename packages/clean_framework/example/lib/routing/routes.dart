import 'package:animations/animations.dart';
import 'package:clean_framework_example/features/home/presentation/home_ui.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_ui.dart';
import 'package:clean_framework_router/clean_framework_router.dart';

enum Routes with RoutesMixin {
  home('/'),
  profile(':pokemon_name');

  const Routes(this.path);

  @override
  final String path;
}

class PokeRouter extends AppRouter<Routes> {
  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(
      routes: [
        AppRoute(
          route: Routes.home,
          builder: (_, __) => HomeUI(),
          routes: [
            AppRoute.custom(
              route: Routes.profile,
              builder: (_, state) {
                return ProfileUI(
                  pokemonName: state.params['pokemon_name'] ?? '',
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
