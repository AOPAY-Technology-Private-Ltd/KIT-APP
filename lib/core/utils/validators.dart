class Validators {
  static String? validateInput(String val) {
    val = val.trim();

    if (val.isEmpty) {
      return "Field is mandatory!";
    }

    if (val.contains('@')) {
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
}