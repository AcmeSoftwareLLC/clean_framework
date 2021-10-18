import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:meta/meta.dart';

abstract class RestRequest extends Request {
  RestRequest(this.method);

  final RestMethod method;

  String get path;

  Map<String, dynamic>? get data => null;
}

abstract class GetRestRequest extends RestRequest {
  GetRestRequest() : super(RestMethod.get);

  Map<String, dynamic>? get params => null;

  @nonVirtual
  @override
  Map<String, dynamic>? get data => params;
}

abstract class PostRestRequest extends RestRequest {
  PostRestRequest() : super(RestMethod.get);
}

abstract class PutRestRequest extends RestRequest {
  PutRestRequest() : super(RestMethod.get);
}

abstract class PatchRestRequest extends RestRequest {
  PatchRestRequest() : super(RestMethod.get);
}

abstract class DeleteRestRequest extends RestRequest {
  DeleteRestRequest() : super(RestMethod.get);
}
