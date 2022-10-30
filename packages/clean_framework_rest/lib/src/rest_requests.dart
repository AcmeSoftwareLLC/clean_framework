import 'dart:typed_data';

import 'package:clean_framework/src/providers/gateway.dart';
import 'package:meta/meta.dart';

import 'rest_method.dart';

abstract class RestRequest extends Request {
  RestRequest(this.method);

  final RestMethod method;

  String get path;

  Map<String, dynamic> get params => {};

  Map<String, String> get headers => {};
}

abstract class JsonRestRequest extends RestRequest {
  JsonRestRequest(super.method);

  Map<String, dynamic> get data => {};
}

abstract class MultiPartRestRequest extends RestRequest {
  MultiPartRestRequest(super.method);

  Map<String, dynamic> get data => {};
}

abstract class BytesRestRequest extends RestRequest {
  BytesRestRequest({required RestMethod method}) : super(method);

  Map<String, dynamic> get data => {};
}

abstract class BinaryDataSrcRestRequest extends RestRequest {
  BinaryDataSrcRestRequest(super.method);

  String get src;
}

abstract class BinaryDataSrcPostRestRequest extends BinaryDataSrcRestRequest {
  BinaryDataSrcPostRestRequest() : super(RestMethod.post);
}

abstract class BinaryDataSrcPutRestRequest extends BinaryDataSrcRestRequest {
  BinaryDataSrcPutRestRequest() : super(RestMethod.put);
}

abstract class BinaryDataRestRequest extends RestRequest {
  BinaryDataRestRequest(super.method);

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

abstract class PostMultiPartRestRequest extends MultiPartRestRequest {
  PostMultiPartRestRequest() : super(RestMethod.post);
}
