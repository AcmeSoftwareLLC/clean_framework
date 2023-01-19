import 'package:meta/meta.dart';

@immutable
abstract class Input {
  const Input();
}

class SuccessInput extends Input {
  const SuccessInput();
}

class FailureInput extends Input {
  const FailureInput({this.message = ''});

  final String message;
}
