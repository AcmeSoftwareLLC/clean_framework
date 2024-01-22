import 'package:meta/meta.dart';

@immutable
abstract class DomainInput {}

class SuccessDomainInput implements DomainInput {
  const SuccessDomainInput();
}

class FailureDomainInput implements DomainInput {
  const FailureDomainInput({this.message = ''});

  final String message;
}
