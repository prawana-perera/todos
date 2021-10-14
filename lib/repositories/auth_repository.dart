import 'package:todos/models/user.dart';

abstract class AuthRepository {
  Future<User?> getLoggedInUser();
  Future<User?> logIn(String username, password);
  Future<void> logOut();
}
