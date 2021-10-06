import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_datastore/amplify_datastore.dart';

import '../amplifyconfiguration.dart';
import 'package:todos/models/ModelProvider.dart';
import 'package:todos/models/Todo.dart';
import 'package:todos/repositories/todo_repository.dart';

class AmplifyTodoRepository implements TodoRepository {
  // amplify plugins
  // static final AmplifyDataStore _dataStorePlugin =
  //     AmplifyDataStore(modelProvider: ModelProvider.instance);

  static Future<void> configure() async {
    if (!Amplify.isConfigured) {
      AmplifyDataStore dataStorePlugin =
          AmplifyDataStore(modelProvider: ModelProvider.instance);

      // add Amplify plugins
      await Amplify.addPlugins([dataStorePlugin]);

      try {
        // configure Amplify
        // note that Amplify cannot be configured more than once!
        await Amplify.configure(amplifyconfig);
      } catch (e) {
        // error handling can be improved for sure!
        // but this will be sufficient for the purposes of this tutorial
        print('An error occurred while configuring Amplify: $e');
      }
    }
  }

  @override
  Future<List<Todo>> getAll() {
    return Amplify.DataStore.query(Todo.classType,
        sortBy: [Todo.PRIORITY.descending()]);
  }

  @override
  Future<Todo> save(Todo todo) async {
    await Amplify.DataStore.save(todo);
    return todo;
  }

  @override
  Future<void> delete(Todo todo) async {
    await Amplify.DataStore.delete(todo);
  }

  @override
  Future<Todo> getById(String id) async {
    var todos =
        await Amplify.DataStore.query(Todo.classType, where: Todo.ID.eq(id));
    return todos[0];
  }
}
