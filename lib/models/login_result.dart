import 'package:todos/models/user.dart';

enum LoginStatus { success, notAuthorised, unconfirmed, error }

class LoginResult {
  final LoginStatus status;
  final User? user;

  const LoginResult(this.status, this.user);
}
