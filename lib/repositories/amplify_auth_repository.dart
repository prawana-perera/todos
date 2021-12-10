import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:todos/models/login_result.dart';
import 'package:todos/models/signup.dart';
import 'package:todos/models/signup_confirmation_result.dart';
import 'package:todos/models/signup_result.dart' as TodosSignupResult;
import 'package:todos/models/user.dart';
import 'package:todos/repositories/auth_repository.dart';

// TODO: convert to GetService?
class AmplifyAuthRepository extends AuthRepository {
  @override
  Future<User?> getLoggedInUser() async {
    try {
      final authUser = await Amplify.Auth.getCurrentUser();

      // Can fetch additional user data
      // final userDetails = await Amplify.Auth.fetchUserAttributes();

      return User(authUser.userId, authUser.username, 'Test User');
    } on SignedOutException {
      return null;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<LoginResult> logIn(String username, password) async {
    try {
      // Clear cached login
      await this.logOut();
      await Amplify.Auth.signIn(username: username, password: password);
      final authUser = await Amplify.Auth.getCurrentUser();

      // TODO: get user details.
      // final userAttribute = await Amplify.Auth.fetchUserAttributes();
      final user = User(authUser.userId, authUser.username, 'Test User');
      return LoginResult(LoginStatus.success, user);
    } on NotAuthorizedException {
      return LoginResult(LoginStatus.notAuthorised, null);
    } on UserNotFoundException {
      return LoginResult(LoginStatus.notAuthorised, null);
    } on UserNotConfirmedException {
      return LoginResult(LoginStatus.unconfirmed, null);
    } catch (e) {
      print('AmplifyAuthRepository.logIn: $e');
      return LoginResult(LoginStatus.error, null);
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print('AmplifyAuthRepository.logOut: $e');
    }
  }

  @override
  Future<TodosSignupResult.SignUpResult> signUp(SignUp request) async {
    Map<String, String> userAttributes = {
      'email': request.username,
      'name': request.name,
    };
    try {
      await Amplify.Auth.signUp(
          username: request.username,
          password: request.password,
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      return TodosSignupResult.SignUpResult(
          TodosSignupResult.SignUpStatus.success);
    } on UsernameExistsException catch (_) {
      return TodosSignupResult.SignUpResult(
          TodosSignupResult.SignUpStatus.duplicateUser);
    } on InvalidPasswordException catch (_) {
      return TodosSignupResult.SignUpResult(
          TodosSignupResult.SignUpStatus.invalidPassword);
    } catch (e) {
      print('AmplifyAuthRepository.signUp: $e');
      return TodosSignupResult.SignUpResult(
          TodosSignupResult.SignUpStatus.error);
    }
  }

  @override
  Future<SignupConfirmationResult> confirmSignUp(
      String email, String confirmationCode) async {
    try {
      await Amplify.Auth.confirmSignUp(
          username: email, confirmationCode: confirmationCode);
      return SignupConfirmationResult(SignupConfirmationStatus.success);
    } on AuthException catch (_) {
      return SignupConfirmationResult(SignupConfirmationStatus.invalidCode);
    } catch (e) {
      print('AmplifyAuthRepository.confirmSignUp: $e');
      return SignupConfirmationResult(SignupConfirmationStatus.error);
    }
  }

  @override
  Future<void> resendSignUpCode(String email) async {
    try {
      final res = await Amplify.Auth.resendSignUpCode(username: email);
      print(res);
    } on AuthException catch (e) {
      print(e.message);
    }
  }
}
