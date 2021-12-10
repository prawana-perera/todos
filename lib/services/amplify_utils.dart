import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';

import '../amplifyconfiguration.dart';

Future<void> configure() async {
  if (!Amplify.isConfigured) {
    try {
      await Amplify.addPlugins([AmplifyAPI(), AmplifyAuthCognito()]);
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      // error handling can be improved for sure!
      print('An error occurred while configuring Amplify: $e');
      throw e;
    }
  }
}
