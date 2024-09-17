import 'package:clean_framework_http_example/features/home/presentation/home_ui.dart';
import 'package:clean_framework_http_example/routing/routes.dart';
import 'package:clean_framework_router/clean_framework_router.dart';

class CleanFrameworkHttpExampleRouter extends AppRouter<Routes> {
  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(
      routes: [
        AppRoute(
          route: Routes.home,
          builder: (_, __) => HomeUI(),
        ),
      ],
    );
  }
}
