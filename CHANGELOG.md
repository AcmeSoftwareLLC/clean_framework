# [1.3.1] - Jun 7, 2022
- Added Feature Flag Management based on OpenFeature specs.
- Added `FeatureBuilder` and `FeatureScope`.

# [1.3.0] - May 12, 2022
- Added `BridgeGatewayProvider`
- Fixed issue with content-type being appended with charset.
- [**Breaking**] Added separate constructor for providing custom `GraphQLService` to `GraphQLExternalInterface`.
- [**Breaking**] Token should be passed using `GraphQLToken` instead of `GraphQLTokenBuilder`.
- Added passing fetch policy to GraphQL requests.
- Added support to modify persistence option for `GraphQLExternalInterface`.
- Upgraded dependencies.
- [**Breaking**] Bumped minimum Flutter version to `3.0.0`.

# [1.2.1] - Apr 25, 2022
- Added `uiTestWidgetBuilder`.
- Added `merge` property to **FirebaseWriteRequest**.
- Made `id` in **FirebaseWriteRequest** optional.
- Added loggers for GraphQL and REST services. The logs can be disabled with the following snippet.

```dart
CleanFrameworkObserver.instance = CleanFrameworkObserver(enableNetworkLogs: false);
```

# [1.2.0] - Mar 20, 2022
- Added `debounce` method to **UseCase**.
- Fixed issue with Form URLEncoded request body format.
- [**Breaking**] Upgraded `mockoon` to **v0.3.0**

# [1.1.6] - Mar 1, 2022
- Added `didUpdatePresenter` to **Presenter**.
- Added `timeout` support for GraphQL requests.  
- Upgraded dependencies.
- Migrated example app to Android v2 embedding.

# [1.1.5] - Jan 10, 2022
- Added `tokenBuilder` and `authHeaderKey` for **GraphQLExternalInterface**.
- Added `headers` in rest requests.
- Now Map<String, dynamic> can be sent in POST request using content types other than url-encoded. (Previously, only url-encoded POST request were supported).
- Added `application/json` as default content type for all rest requests and `utf-8` as default encoding.
- Removed `intitialTimeout` from **uiTest** as it's been deprecated.
- Added route state to navigator builder.
- Upgraded dependencies.

# [1.1.4] - Dec 8, 2021
- Added `observers` and `navigatorBuilder` to **AppRouter**.
- Improved duplication handling logic for `onOutputUpdate`.
- Added `postFrame` callback to **uiTest**, which overrides the default `pumpAndSettle`. Fixes [#31](https://github.com/MattHamburger/clean_framework/issues/31).
- Added `router` argument to **uiTest** to enable navigating between routes inside the test block.
- Added `setupUITest()` method to setup provider context and router for all the subsequent **uiTest**s.

# 1.1.3 Upgraded to stable version of `riverpod`
- `riverpod` version upgraded to `^1.0.0`

# 1.1.2 Introduction Codelab
- Added the Introduction to Clean Framework Codelab under the docs folder. The codelab is also published, see the public link on the README file.

# 1.1.1 Mixed External Interface and Router
- Merged into one class the Direct and Watcher External Interfaces, this is a breaking change for any class using this ancestor. The [onTransport] method is replaced by [handleRequest]. Please refer to the code example and tests to understand the migration effort.

- Added a new Router based on the library Go Router. This default is much easier to use and can be overridden during tests. Please refer to the code example for usage.

- Minor refactor changes to remove unnecessary or duplicated code. This includes the removal of the Equatable ancestor on Inputs and derivatives, given that during tests is not practical to compare inputs. If your implementation does these comparisons on tests, you can implement the EquatableMixin in your Input implementations.

# 1.0.0-prerelease

- First release of our improved library. The stable of classes and utilities included allows the implementation of Bob Martin's Clean Architecture with defined layer separation, using Riverpod-style Providers.
