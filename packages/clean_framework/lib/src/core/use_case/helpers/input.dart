import 'package:clean_framework/src/core/use_case/helpers/output.dart';
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

class NoSubscriptionFailureInput<O extends Output> extends FailureInput {
  const NoSubscriptionFailureInput()
      : super(message: 'No subscription exists for this request of $O');
}
