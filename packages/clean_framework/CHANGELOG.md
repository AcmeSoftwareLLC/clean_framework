# Changelog
## 2.1.0
**Mar 17, 2023**
- Added `ExternalInterfaceDelegate`.

## 2.0.10
**Mar 16, 2023**
- Added `DependencyProvider`.
- Added `locate` method to **ExternalInterface**.

## 2.0.9
**Mar 14, 2023**
- Bumped dependencies to latest version.
- Logs error caught by External Interface with stacktrace.

## 2.0.8
**Mar 9, 2023**
- Fixed **WatcherGateway** not updating entity properly.
- Added `getUseCaseFromContext` to **UseCaseProvider**s.

## 2.0.7
**Feb 22, 2023**
- Added `debugEntity` and `debugEntityUpdate` to **UseCase**. The `entity` getter/setter is now protected.
- Bumped dependencies to latest version.

## 2.0.6
**Feb 13, 2023**
- Fixed `Deserializer.getList()` returning `defaultValue` on some cases.

## 2.0.5
**Feb 1, 2023**
- Fixed casting issue with `Deserializer.getList()`

## 2.0.4
**Jan 27, 2023**
- Added `withSilencedUpdate` for **UseCase**.
- `onDestroy` method in **Presenter** will now be called immediately at dispose. Any actions that causes UI to rebuild should be avoided in this method.
For entity updates that do not need to rebuild the UI, should be wrapped inside `withSilencedUpdate` in UseCase.

## 2.0.3
**Jan 25, 2023**
- Fixed issue with `overrideWith` for external interface provider.
- `copyWith` method for `Entity` now throws unimplemented if used without overriding.

## 2.0.2
**Jan 24, 2023**
- Added `overrideWith` for providers.

## 2.0.1
**Jan 19, 2023**
- Added `onOutput` method for **Presenter**
- Fixed issue with Flutter Web

## 2.0.0
**Jan 17, 2023**
**Breaking Change**
- Removed dependencies on sub packages. Sub-packages can be added separately as per the requirement.
```text
Sub-packages:
- clean_framework_router
- clean_framework_graphql
- clean_framework_rest
- clean_framework_firestore
- clean_framework_test
```
- Added `AppProviderScope`
- Remove old feature flagging classes in favor of new open feature based classes
- Simplified Either implementation
- Introduced `transformers` to **UseCase**; use cases are now lazily instantiated
- Simplified provider creation and usage
- Added `UseCaseProvider.autoDispose`
- Added `UseCaseProviderBridge`

For migration guide, please refer to [the docs](https://docs.page/AcmeSoftwareLLC/clean_framework/codelabs/clean-framework/migration-guide).

## 1.5.0
**Nov 1, 2022**
- Breakdown into sub packages.
- Moved test helpers to `clean_framework_test` package.
- **RestSuccessResponse**'s data is subtype of `Object` instead of `dynamic`.

## 1.5.0-dev.0
**Oct 31, 2022**
- Breakdown into sub packages.
- Moved test helpers to `clean_framework_test` package.
- **RestSuccessResponse**'s data is subtype of `Object` instead of `dynamic`.

## 1.4.2
**Sep 13, 2022**
- Added support for GraphQL Schema Stitching.
- Added support for changing GraphQL error policy in request level.
- Bumped dependencies to their latest version.

## 1.4.1
**Aug 31, 2022**
- Bumped dependencies to their latest version.

## 1.4.0 
**Aug 3, 2022**
- Added `push` method to the router.
- Added `AppRouter.page` and `AppRouter.custom`.
- Added `Deserializer` to help with deserializing JSON data.
- Added support for form data and multipart request through `RestExternalInterface`.
- Updated dependencies to latest version.
- [**Breaking**] Removed `valueType` from **FeatureBuilder**.

## 1.3.1 
**Jun 7, 2022**
- Added Feature Flag Management based on OpenFeature specs.
- Added `FeatureBuilder` and `FeatureScope`.

## 1.3.0 
**May 12, 2022**
- Added `BridgeGatewayProvider`
- Fixed issue with content-type being appended with charset.
- [**Breaking**] Added separate constructor for providing custom `GraphQLService` to `GraphQLExternalInterface`.
- [**Breaking**] Token should be passed using `GraphQLToken` instead of `GraphQLTokenBuilder`.
- Added passing fetch policy to GraphQL requests.
- Added support to modify persistence option for `GraphQLExternalInterface`.
- Upgraded dependencies.
- [**Breaking**] Bumped minimum Flutter version to `3.0.0`.

## 1.2.1 
**Apr 25, 2022**
- Added `uiTestWidgetBuilder`.
- Added `merge` property to **FirebaseWriteRequest**.
- Made `id` in **FirebaseWriteRequest** optional.
- Added loggers for GraphQL and REST services. The logs can be disabled with the following snippet.

```dart
CleanFrameworkObserver.instance = CleanFrameworkObserver(enableNetworkLogs: false);
```

## 1.2.0 
**Mar 20, 2022**
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
- Added `postFrame` callback to **uiTest**, which overrides the default `pumpAndSettle`. Fixes [#31](https://github.com/AcmeSoftwareLLC/clean_framework/issues/31).
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
