class Validators {
  static String? validateInput(String val) {
    val = val.trim();

    if (val.isEmpty) {
      return "Field is mandatory!";
    }

    if (val.contains('@') || RegExp(r'[a-zA-Z]').hasMatch(val)) {
      return validateEmail(val);
    }

    return validateMobile(val);
  }

  static String? validateMobile(String val) {
    val = val.trim();

    if (val.isEmpty) {
      return "Mobile Number is required";
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(val)) {
      return "Please enter a valid 10-digit mobile number";
    }

    return null;
  }

  static String? validateEmail(String val) {
    val = val.trim();

    if (val.isEmpty) {
      return "Email is required";
    }

    if (!RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    ).hasMatch(val)) {
      return "Please enter a valid email address";
    }

    return null;
  }

  static String? validatePan(String? val) {
    if (val == null || val.trim().isEmpty) {
      return null;
    }

    final panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    if (!panRegExp.hasMatch(val.trim().toUpperCase())) {
      return "Please enter a valid PAN number (e.g., ABCDE1234F)";
    }

    return null;
  }

  static String? validateAadhaar(String? val) {
    if (val == null || val.trim().isEmpty) {
      return null;
    }

    final aadharRegExp = RegExp(r'^[0-9]{12}$');

    if (!aadharRegExp.hasMatch(val.trim())) {
      return "Please enter a valid 12-digit Aadhaar number";
    }

    return null;
  }
}