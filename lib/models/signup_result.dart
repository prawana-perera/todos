enum SignUpStatus { success, duplicateUser, invalidPassword, error }

class SignUpResult {
  final SignUpStatus status;

  const SignUpResult(this.status);
}
