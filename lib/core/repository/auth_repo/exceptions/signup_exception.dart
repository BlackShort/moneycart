class SignupException {
  final String message;
  const SignupException([
    this.message = 'An Unknown error occurred.',
  ]);

  factory SignupException.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupException('Please enter a stronger password.');
      case 'invalid-email':
        return const SignupException('Email is not valid or badly formatted.');
      case 'email-already-in-use':
        return const SignupException(
            'An account already exist with this email.');
      case 'operation-not-allowed':
        return const SignupException(
            'Operation is not allowed. Please contact support.');
      case 'user-disabled':
        return const SignupException(
            'This user has been disabled. Please contact support for help.');
      default:
        return const SignupException();
    }
  }
}
