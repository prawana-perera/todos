enum SignupConfirmationStatus { success, invalidCode, error }

class SignupConfirmationResult {
  final SignupConfirmationStatus status;

  const SignupConfirmationResult(this.status);
}
