enum PasswordValidationResult {
  valid,
  tooShort,
  tooLong,
  missingLetter,
  missingNumber,
  missingSpecial,
}

class PasswordPolicy {
  static const int minLength = 8;
  static const int maxLength = 15;

  static PasswordValidationResult validate(String password) {
    if (password.length < minLength) {
      return PasswordValidationResult.tooShort;
    }

    if (password.length > maxLength) {
      return PasswordValidationResult.tooLong;
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(password)) {
      return PasswordValidationResult.missingLetter;
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      return PasswordValidationResult.missingNumber;
    }

    if (!RegExp(r'[@$!%*#?&]').hasMatch(password)) {
      return PasswordValidationResult.missingSpecial;
    }

    return PasswordValidationResult.valid;
  }
}