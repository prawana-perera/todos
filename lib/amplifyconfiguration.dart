import 'package:flutter_dotenv/flutter_dotenv.dart';

String amplifyconfig = '''
{
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
