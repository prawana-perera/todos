import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';

import '../amplifyconfiguration.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/repositories/todo_repository.dart';

class AmplifyTodoRepository implements TodoRepository {
  static Future<void> configure() async {
    if (!Amplify.isConfigured) {
      try {
        Amplify.addPlugin(AmplifyAPI());
        await Amplify.configure(amplifyconfig);
      } catch (e) {
        // error handling can be improved for sure!
        print('An error occurred while configuring Amplify: $e');
      }
    }
  }

  @override
  Future<List<Todo>> getAll() async {
    String graphQLDocument = '''query ListTodos {
      listTodos {
        items {
          id
          name
          description
          priority
        }
        nextToken
      }
    }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);

    // Map<String, dynamic> map = jsonDecode(data)['listTodos']['items'];
    // print('map' + map.toString());

    return (jsonDecode(data)['listTodos']['items'] as List)
        .map((todo) => Todo.fromJson(todo))
        .toList();
  }

  @override
  Future<Todo> getById(String id) async {
    String graphQLDocument = '''query GetTodo(\$id: ID!) {
      getTodo(id: \$id) {
        id
        name
        description
        priority
      }
    }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'id': id}));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);

    return Todo.fromJson(jsonDecode(data)['getTodo']);
  }

  @override
  Future<Todo> add(Todo todo) async {
    String graphQLDocument =
        '''mutation CreateTodo(\$name: String!, \$description: String, \$priority: Int!) {
              createTodo(input: {name: \$name, description: \$description, priority: \$priority}) {
                id
                name
                description
                priority
              }
        }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      'name': todo.name,
      'description': todo.description,
      'priority': todo.priority
    }));

    var response = await operation.response;
    var data = response.data;

    print('Mutation result: ' + data);

    return Todo.fromJson(jsonDecode(data)['createTodo']);
  }

  @override
  Future<Todo> update(Todo todo) async {
    String graphQLDocument =
        '''mutation UpdateTodo(\$id: ID!, \$name: String!, \$description: String, \$priority: Int!) {
          updateTodo(input: { id: \$id, name: \$name, description: \$description, priority: \$priority}) {
            id
            name
            description
            priority
          }
    }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      'id': todo.id,
      'name': todo.name,
      'description': todo.description,
      'priority': todo.priority
    }));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);

    return Todo.fromJson(jsonDecode(data)['updateTodo']);
  }

  @override
  Future<void> delete(Todo todo) async {
    String graphQLDocument = '''mutation deleteTodo(\$id: ID!) {
          deleteTodo(input: { id: \$id }) {
            id
            name
            description
          }
    }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'id': todo.id}));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);
  }
}
