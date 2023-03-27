# Changelog
## 0.2.0
**Mar 27, 2023**
- Bumps dependencies to latest version.
- Adds `ConnectionHttpFailureResponse` to handle connection errors.
- Renames `CancelledFailureResponse` to `CancelledHttpFailureResponse`.

## 0.1.5
**Mar 21, 2023**
- Allows setting `responseType`, `contentType` and `cancelToken` through *HttpRequest*.

## 0.1.4
**Mar 20, 2023**
- Bumped dependencies to latest version.
- Reports `PlainHttpSuccessResponse` instead of throwing on null response data.

## 0.1.3
**Mar 17, 2023**
- Fixed multiple `Dio` instance being shared between external interfaces.

## 0.1.2
**Mar 17, 2023**
- Made timeouts configurable in `HttpOptions`.

## 0.1.1
**Mar 17, 2023**
- `data` & `queryParameters` are made optional in request.

## 0.1.0
**Mar 17, 2023**
- Initial Release