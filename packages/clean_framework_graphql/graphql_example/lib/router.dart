import 'package:graphql_example/features/home/presentation/home_ui.dart';
import 'package:clean_framework_router/clean_framework_router.dart';

class ExampleRouter extends AppRouter<Routes> {
  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(
      debugLogDiagnostics: true,
      routes: [
        AppRoute(
          route: Routes.home,
          builder: (_, __) => HomeUI(),
        ),
      ],
    );
  }
}

enum Routes with RoutesMixin {
  home('/');

  const Routes(this.path);

  @override
  final String path;
}
