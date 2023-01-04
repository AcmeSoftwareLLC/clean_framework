import 'package:clean_framework_example/features/home/presentation/home_ui.dart';
import 'package:clean_framework_router/clean_framework_router.dart';

enum Routes with RoutesMixin {
  home('/');

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
          builder: (context, state) => HomeUI(),
        ),
      ],
    );
  }
}
