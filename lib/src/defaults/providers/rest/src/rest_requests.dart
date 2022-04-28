import 'dart:typed_data';

import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/defaults/network_service.dart';
import 'package:meta/meta.dart';

abstract class RestRequest extends Request {
  RestRequest(this.method);

  final RestMethod method;

  String get path;

  Map<String, String> get headers => {};
}

abstract class JsonRestRequest extends RestRequest {
  JsonRestRequest(method) : super(method);

  Map<String, dynamic> get data => {};
}

abstract class BinaryDataSrcRestRequest extends RestRequest {
  BinaryDataSrcRestRequest(this.method) : super(method);
  final RestMethod method;

  String get src;
}

abstract class BinaryDataSrcPostRestRequest extends BinaryDataSrcRestRequest {
  BinaryDataSrcPostRestRequest() : super(RestMethod.post);
}

abstract class BinaryDataSrcPutRestRequest extends BinaryDataSrcRestRequest {
  BinaryDataSrcPutRestRequest() : super(RestMethod.put);
}

abstract class BinaryDataRestRequest extends RestRequest {
  BinaryDataRestRequest(this.method) : super(method);
  final RestMethod method;

  Uint8List get binaryData;
}

abstract class BinaryDataPostRestRequest extends BinaryDataRestRequest {
  BinaryDataPostRestRequest() : super(RestMethod.post);
}

abstract class BinaryDataPutRestRequest extends BinaryDataRestRequest {
  BinaryDataPutRestRequest() : super(RestMethod.put);
}

abstract class GetRestRequest extends JsonRestRequest {
  GetRestRequest() : super(RestMethod.get);

  Map<String, dynamic> get params => {};

  @nonVirtual
  @override
  Map<String, dynamic> get data => params;
}

abstract class PostRestRequest extends JsonRestRequest {
  PostRestRequest() : super(RestMethod.post);
}

abstract class PutRestRequest extends JsonRestRequest {
  PutRestRequest() : super(RestMethod.put);
}

abstract class PatchRestRequest extends JsonRestRequest {
  PatchRestRequest() : super(RestMethod.patch);
}

abstract class DeleteRestRequest extends JsonRestRequest {
  DeleteRestRequest() : super(RestMethod.delete);
}
