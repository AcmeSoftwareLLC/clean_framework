import 'package:meta/meta.dart';

@immutable
class Input {
  const Input();
}

class SuccessInput implements Input {
  const SuccessInput();
}

class FailureInput implements Input {
  const FailureInput({this.message = ''});

  final String message;
}
