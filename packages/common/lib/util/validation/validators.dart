mixin Validator {

  bool validate(String input);
}

class EmailValidator implements Validator {

  static final _emailReg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"
  );

  @override
  bool validate(String input) => _emailReg.hasMatch(input);
}

class PasswordValidator implements Validator {

  @override
  bool validate(String input) => input.length >= 8;
}

class NotEmptyValidator implements Validator {

  @override
  bool validate(String input) => input.isNotEmpty;
}
