import 'package:uniform/uniform.dart';

class EmailInputFieldValidator implements InputFieldValidator {
  const EmailInputFieldValidator();

  @override
  InputFieldError resolve(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(\.[a-zA-Z\d-]{2,})+$',
    );

    if (!emailRegex.hasMatch(value)) {
      return InputFieldError('Please input a valid email.');
    }

    return InputFieldError.none();
  }
}
