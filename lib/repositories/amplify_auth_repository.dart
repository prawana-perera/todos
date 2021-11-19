import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:todos/models/user.dart';
import 'package:todos/repositories/auth_repository.dart';

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
  Future<User?> logIn(String username, password) async {
    try {
      await Amplify.Auth.signIn(username: username, password: password);
      final authUser = await Amplify.Auth.getCurrentUser();

      return User(authUser.userId, authUser.username, 'Test User');
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      throw e;
    }
  }
}
