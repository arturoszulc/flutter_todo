class MyError {
  //auth custom errors
  static const String signInTimeout =
      'Something went wrong... Try again later.';
  static const String signInGoogle =
      'Couldn\'t sign in with Google. Check your Internet connection.';

  //validation errors
  static const String invalidEmail =
      'Enter a valid e-mail, like example@example.com';
  static const String invalidPassword =
      'Password must be at least 6 characters long';
  static const String invalidUsername =
      'Username must contain 1-10 alphanumeric characters';
  static const String invalidTodo = 'Remove special characters';
}
