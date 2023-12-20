class Validate {
  static bool usernameValid(String? value) {
    return value == null || value == "" ? false : true;
  }

  static bool passwordValid(String? value) {
    return value == null || value == "" ? false : true;
  }
}