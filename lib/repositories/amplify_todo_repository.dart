import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:todos/models/data_event_subscription.dart';
import 'package:todos/models/todo.dart';
import 'package:todos/models/user.dart';
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
  @override
  Future<List<Todo>> getAll() async {
    String graphQLDocument = '''query GetAll {
      getAll {
        items {
          id
          title
          description
          priority
          status
          owner
          createdAt
          modifiedAt
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

    return (jsonDecode(data)['getAll']['items'] as List)
        .map((todo) => Todo.fromJson(todo))
        .toList();
  }

  @override
  Future<Todo> getById(String id) async {
    String graphQLDocument = '''query GetById(\$id: ID!) {
      getById(id: \$id) {
        id
        title
        description
        priority
        status
        owner
        createdAt
        modifiedAt
      }
    }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'id': id}));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);

    return Todo.fromJson(jsonDecode(data)['getById']);
  }

  @override
  Future<Todo> add(Todo todo) async {
    String graphQLDocument =
        '''mutation Create(\$title: String!, \$description: String, \$priority: Priority!) {
              create(input: {title: \$title, description: \$description, priority: \$priority}) {
                id
                title
                description
                priority
                status
                owner
                createdAt
                modifiedAt
              }
        }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      'title': todo.title,
      'description': todo.description,
      'priority': todo.priority
    }));

    var response = await operation.response;
    var data = response.data;

    print('Mutation result: ' + data);

    return Todo.fromJson(jsonDecode(data)['create']);
  }

  @override
  Future<Todo> update(Todo todo) async {
    String graphQLDocument =
        '''mutation Update(\$id: ID!, \$title: String!, \$description: String, \$priority: Priority!) {
            update(input: { id: \$id, title: \$title, description: \$description, priority: \$priority}) {
              id
              title
              description
              priority
              status
              owner
              createdAt
              modifiedAt
          }
    }''';

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'priority': todo.priority
    }));

    var response = await operation.response;
    var data = response.data;

    print('Query result: ' + data);

    return Todo.fromJson(jsonDecode(data)['update']);
  }

  @override
  Future<void> delete(Todo todo) async {
    String graphQLDocument = '''mutation Delete(\$id: ID!) {
          delete(id: \$id) {
            id
            title
            description
            priority
            status
            owner
            createdAt
            modifiedAt
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
  DataEventSubscription subscribe(User user,
      {required OnCreate onCreate,
      required OnUpdate onUpdate,
      required OnDelete onDelete}) {
    return AmplifyGraphQLSubscription([
      _subscribeOnCreate(user, onCreate),
      _subscribeOnUpdate(user, onUpdate),
      _subscribeOnDelete(user, onDelete)
    ]);
  }

  GraphQLSubscriptionOperation _subscribeOnCreate(
      User user, OnCreate onCreate) {
    String graphQLDocument = '''subscription OnTodoAdded(\$owner: String!) {
        onTodoAdded(owner: \$owner) {
          id
          title
          description
          priority
          status
          owner
          createdAt
          modifiedAt
        }
      }''';

    var opertation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'owner': user.id}),
        onData: (event) {
          print(
              'onTodoAdded - Subscription event data received: ${event.data}');
          onCreate(
              Todo.fromJson(jsonDecode(event.data as String)['onTodoAdded']));
        },
        onEstablished: () {
          print('onTodoAdded - Subscription established');
        },
        onError: (e) {
          print('onTodoAdded - Subscription failed with error: $e');
        },
        onDone: () {
          print('onTodoAdded - Subscription has been closed successfully');
        });

    return opertation;
  }

  GraphQLSubscriptionOperation _subscribeOnUpdate(
      User user, OnUpdate onUpdate) {
    String graphQLDocument = '''subscription OnTodoUpdated(\$owner: String!) {
        onTodoUpdated(owner: \$owner) {
          id
          title
          description
          priority
          status
          owner
          createdAt
          modifiedAt
        }
      }''';

    var opertation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'owner': user.id}),
        onData: (event) {
          print(
              'onTodoUpdated - Subscription event data received: ${event.data}');
          onUpdate(
              Todo.fromJson(jsonDecode(event.data as String)['onTodoUpdated']));
        },
        onEstablished: () {
          print('onTodoUpdated - Subscription established');
        },
        onError: (e) {
          print('onTodoUpdated - Subscription failed with error: $e');
        },
        onDone: () {
          print('onTodoUpdated - Subscription has been closed successfully');
        });

    return opertation;
  }

  GraphQLSubscriptionOperation _subscribeOnDelete(
      User user, OnDelete onDelete) {
    String graphQLDocument = '''subscription OnTodoDeleted(\$owner: String!) {
        onTodoDeleted(owner: \$owner) {
          id
          title
          description
          priority
          status
          owner
          createdAt
          modifiedAt
        }
      }''';

    var opertation = Amplify.API.subscribe(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {'owner': user.id}),
        onData: (event) {
          print(
              'onTodoDeleted - Subscription event data received: ${event.data}');
          onDelete(jsonDecode(event.data as String)['onTodoDeleted']['id']);
        },
        onEstablished: () {
          print('onTodoDeleted - Subscription established');
        },
        onError: (e) {
          print('onTodoDeleted - Subscription failed with error: $e');
        },
        onDone: () {
          print('onTodoDeleted - Subscription has been closed successfully');
        });

    return opertation;
  }
}
