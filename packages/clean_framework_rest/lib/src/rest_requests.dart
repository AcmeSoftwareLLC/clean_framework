import 'dart:typed_data';

import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_rest/src/rest_method.dart';
import 'package:meta/meta.dart';

abstract class RestRequest extends Request {
  const RestRequest(this.method);

  final RestMethod method;

  String get path;

  Map<String, dynamic> get params => {};

  Map<String, String> get headers => {};
}

abstract class JsonRestRequest extends RestRequest {
  const JsonRestRequest(super.method);

  Map<String, dynamic> get data => {};
}

abstract class MultiPartRestRequest extends RestRequest {
  const MultiPartRestRequest(super.method);

  Map<String, dynamic> get data => {};
}

abstract class BytesRestRequest extends RestRequest {
  const BytesRestRequest({required RestMethod method}) : super(method);

  Map<String, dynamic> get data => {};
}

abstract class BinaryDataSrcRestRequest extends RestRequest {
  const BinaryDataSrcRestRequest(super.method);

  String get src;
}

abstract class BinaryDataSrcPostRestRequest extends BinaryDataSrcRestRequest {
  const BinaryDataSrcPostRestRequest() : super(RestMethod.post);
}

abstract class BinaryDataSrcPutRestRequest extends BinaryDataSrcRestRequest {
  const BinaryDataSrcPutRestRequest() : super(RestMethod.put);
}

abstract class BinaryDataRestRequest extends RestRequest {
  const BinaryDataRestRequest(super.method);

  Uint8List get binaryData;
}

abstract class BinaryDataPostRestRequest extends BinaryDataRestRequest {
  const BinaryDataPostRestRequest() : super(RestMethod.post);
}

abstract class BinaryDataPutRestRequest extends BinaryDataRestRequest {
  const BinaryDataPutRestRequest() : super(RestMethod.put);
}

abstract class GetRestRequest extends JsonRestRequest {
  const GetRestRequest() : super(RestMethod.get);

  @nonVirtual
  @override
  Map<String, dynamic> get data => params;
}

abstract class PostRestRequest extends JsonRestRequest {
  const PostRestRequest() : super(RestMethod.post);
}

abstract class PutRestRequest extends JsonRestRequest {
  const PutRestRequest() : super(RestMethod.put);
}

abstract class PatchRestRequest extends JsonRestRequest {
  const PatchRestRequest() : super(RestMethod.patch);
}

abstract class DeleteRestRequest extends JsonRestRequest {
  const DeleteRestRequest() : super(RestMethod.delete);
}

abstract class PostMultiPartRestRequest extends MultiPartRestRequest {
  const PostMultiPartRestRequest() : super(RestMethod.post);
}
