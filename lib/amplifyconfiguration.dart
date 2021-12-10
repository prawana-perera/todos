import 'package:flutter_dotenv/flutter_dotenv.dart';

String amplifyconfig = '''
{
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "IdentityManager": {
                    "Default": {}
                },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "${dotenv.env['COGNITO_USER_POOL_ID']}",
                        "AppClientId": "${dotenv.env['COGNITO_APP_CLIENT_ID']}",
                        "Region": "${dotenv.env['AWS_REGION']}"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "${dotenv.env['COGNITO_AUTH_FLOW_TYPE']}"
                    }
                }
            }
        }
    },
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "Todos": {
                    "endpointType": "GraphQL",
                    "endpoint": "${dotenv.env['APPSYNC_ENDPOINT']}",
                    "region": "${dotenv.env['AWS_REGION']}",
                    "authorizationType": "${dotenv.env['APPSYNC_AUTHORIZATION_TYPE']}",
                    "apiKey": "${dotenv.env['APPSYNC_API_KEY']}"
                }
            }
        }
    }
}
''';
