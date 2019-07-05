class CredentialsValidate {
  static String validatePassword(String value) {
    if (value.length < 3)
      return 'Password must be more than 2 charaters';

    return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';

    return null;
  }

  static String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 characters';

    return null;
  }

}