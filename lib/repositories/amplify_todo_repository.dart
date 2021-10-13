import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:todos/models/data_event_subscription.dart';

import '../amplifyconfiguration.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/repositories/todo_repository.dart';

class AmplifyGraphQLSubscription extends DataEventSubscription {
  List<GraphQLSubscriptionOperation> _subscriptions;

  AmplifyGraphQLSubscription(List<GraphQLSubscriptionOperation> subscriptions)
      : this._subscriptions = subscriptions;

  @override
  void cancel() {
    _subscriptions.forEach((subscription) => subscription.cancel());
  }
}

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
          owner
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
        owner
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
                owner
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
            owner
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
            owner
          }
    }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'id': todo.id}));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);
  }

  @override
  DataEventSubscription subscribe(
      {required OnCreate onCreate,
      required OnUpdate onUpdate,
      required OnDelete onDelete}) {
    return AmplifyGraphQLSubscription([
      _subscribeOnCreate(onCreate),
      _subscribeOnUpdate(onUpdate),
      _subscribeOnDelete(onDelete)
    ]);
  }

  GraphQLSubscriptionOperation _subscribeOnCreate(OnCreate onCreate) {
    String graphQLDocument = '''subscription OnCreateTodo {
        onCreateTodo {
          id
          name
          description
          priority
        }
      }''';

    var opertation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(document: graphQLDocument),
        onData: (event) {
          print(
              'onCreateTodo - Subscription event data received: ${event.data}');
          onCreate(
              Todo.fromJson(jsonDecode(event.data as String)['onCreateTodo']));
        },
        onEstablished: () {
          print('onCreateTodo - Subscription established');
        },
        onError: (e) {
          print('onCreateTodo - Subscription failed with error: $e');
        },
        onDone: () {
          print('onCreateTodo - Subscription has been closed successfully');
        });

    return opertation;
  }

  GraphQLSubscriptionOperation _subscribeOnUpdate(OnUpdate onUpdate) {
    String graphQLDocument = '''subscription OnUpdateTodo {
        onUpdateTodo {
          description
          id
          name
          priority
        }
      }''';

    var opertation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(document: graphQLDocument),
        onData: (event) {
          print(
              'onUpdateTodo - Subscription event data received: ${event.data}');
          onUpdate(
              Todo.fromJson(jsonDecode(event.data as String)['onUpdateTodo']));
        },
        onEstablished: () {
          print('onUpdateTodo - Subscription established');
        },
        onError: (e) {
          print('onUpdateTodo - Subscription failed with error: $e');
        },
        onDone: () {
          print('onUpdateTodo - Subscription has been closed successfully');
        });

    return opertation;
  }

  GraphQLSubscriptionOperation _subscribeOnDelete(OnDelete onDelete) {
    String graphQLDocument = '''subscription OnDeleteTodo {
        onDeleteTodo {
          id
        }
      }''';

    var opertation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(document: graphQLDocument),
        onData: (event) {
          print(
              'onDeleteTodo - Subscription event data received: ${event.data}');
          onDelete(jsonDecode(event.data as String)['onDeleteTodo']['id']);
        },
        onEstablished: () {
          print('onDeleteTodo - Subscription established');
        },
        onError: (e) {
          print('onDeleteTodo - Subscription failed with error: $e');
        },
        onDone: () {
          print('onDeleteTodo - Subscription has been closed successfully');
        });

    return opertation;
  }
}
