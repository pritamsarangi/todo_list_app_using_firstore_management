import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoslist/models/todo_list.dart';

const String TODO_COLLECTION_REF = 'todos';

class DatabaseServices {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Todo> _todosRef;

  DatabaseServices() {
    _todosRef = _firestore.collection(TODO_COLLECTION_REF).withConverter<Todo>(
        fromFirestore: (snapshots, _) => Todo.fromJson(snapshots.data()!),
        toFirestore: (todo, _) => todo.toJson());
  }

  Future <List<Todo>> getTodos() async {
    final QuerySnapshot<Todo> querySnapshot = await _todosRef.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future <void> addTodo(Todo todo) async {
    final doc =  await _todosRef.add(todo);
    todo = todo.copyWith(id: doc.id);
    await updateTodo(doc.id, todo);

  }

 Future <void> updateTodo(String todoId, Todo todo) async {
    await _todosRef.doc(todoId).update(todo.toJson());
  }

  Future <void> deleteTodo(String todoId) async {
    await _todosRef.doc(todoId).delete();
  }
}

