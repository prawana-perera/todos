import 'package:todos/models/login_result.dart';
import 'package:todos/models/signup.dart';
import 'package:todos/models/signup_confirmation_result.dart';
import 'package:todos/models/signup_result.dart';
import 'package:todos/models/user.dart';

abstract class AuthRepository {
  Future<User?> getLoggedInUser();
  Future<LoginResult> logIn(String username, password);
  Future<void> logOut();
  Future<SignUpResult> signUp(SignUp request);
  Future<SignupConfirmationResult> confirmSignUp(
      String email, String confirmationCode);
  Future<void> resendSignUpCode(String email);
}
