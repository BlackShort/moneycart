class SigninException {
  final String? message;

  const SigninException([
    this.message = 'An unknown error occurred.',
  ]);

  factory SigninException.fromCode(String code) {
    switch (code) {
      case 'user-not-found':
        return const SigninException('No user found with this email.');
      case 'invalid-password':
        return const SigninException('Invalid Email or Password.');
      case 'wrong-password':
        return const SigninException('Wrong password provided.');
      case 'user-disabled':
        return const SigninException('User has been disabled.');
      case 'too-many-requests':
        return const SigninException('Too many requests. Try again later.');
      case 'invalid-email':
        return const SigninException('Invalid email provided.');
      default:
        return const SigninException();
    }
  }
}
