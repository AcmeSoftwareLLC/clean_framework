# Clean Framework Routing
Clean Framework bundles a high level API for mutating navigation stack of Flutter application based on [Navigator 2.0](https://flutter.dev/go/navigator-with-router).

For more detail on Navigator 2.0, read the official article [Learning Flutter’s new navigation and routing system](https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade).


## CFRouterScope
Responsible for providing **CFRouter** instance to its descendants.

Wrap your whole app with **CFRouterScope** so that the underlying router is accessible from everywhere.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CFRouterScope(
      initialRoute: '/home',
      routeGenerator: (name) {
        if(name == '/home') return HomePage();
      },
      builder: (context) {
        return MaterialApp.router(
          routeInformationParser: CFRouteInformationParser(),
          routerDelegate: CFRouterDelegate(context),
        );
      },
    );
  }
}
```

## Accessing Router
The router can be accessed in two ways:
- `CFRouterScope.of(context)`
- `context.router`

### Router Methods
Method | Description
--- | ---
push(name, {arguments}) | Pushes the route onto the navigation stack.
replaceWith(name, {arguments}) | Replaces the current route with the route provided.
update(pageList) | Updates the navigation stack in granular level.
pop([value]) | Pops the current route.
popUntil(name) | Pops repeteadly until the route is at the top of the navigation stack.
reset() | Resets the route to be initial route.
updateInitialRoute(name) | Similar to reset, but an arbitary route can be provided to be an initial route.
currentPage | The top-most route page in the navigation stack.
previousPage | The route just below the current route page.
pages | All the pages in the stack.