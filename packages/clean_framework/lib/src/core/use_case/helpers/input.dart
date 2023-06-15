import 'package:meta/meta.dart';

@immutable
abstract class Input {}

class SuccessInput implements Input {
  const SuccessInput();
}

class FailureInput implements Input {
  const FailureInput({this.message = ''});

  final String message;
}
