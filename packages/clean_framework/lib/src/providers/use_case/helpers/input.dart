import 'package:clean_framework/src/providers/use_case/helpers/output.dart';
import 'package:meta/meta.dart';

@immutable
abstract class Input {}

class SuccessInput extends Input {}

class FailureInput extends Input {
  FailureInput({this.message = ''});

  final String message;
}

class NoSubscriptionFailureInput<O extends Output> extends FailureInput {
  NoSubscriptionFailureInput()
      : super(message: 'No subscription exists for this request of $O');
}
