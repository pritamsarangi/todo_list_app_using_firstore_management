import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoslist/Services/database_services.dart';
import 'package:todoslist/models/todo_list.dart';
import 'new_todo_screen.dart';

class Home_Screen extends StatefulWidget {
  final Todo? todo;
  Home_Screen({Key? key , this.todo}) :super(key: key);


  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  List<Todo> _todos = [];
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final DatabaseServices _databaseServices = DatabaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: RefreshIndicator(onRefresh: _refreshTodos, child: _buildUI()),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTodoScreen(todo: widget.todo)),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _refreshTodos() async {
    try {
      List<Todo> refreshedTodos = await _databaseServices.getTodos();

      setState(() {
        _todos = refreshedTodos;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todos refreshed successfully'),
        ),
      );
    } catch (error) {
      print('Error refreshing todos: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error refreshing todos: $error'),
        ),
      );
    }
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: const Text('Simple Todo'),
      centerTitle: true,
      backgroundColor: Colors.deepOrange,
      actions: [
        IconButton(
          onPressed: _refreshTodos,
          icon: Icon(Icons.refresh_sharp),
        )
      ],
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _databaseServices.getTodos(),
              builder: (context, AsyncSnapshot<List<Todo>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  List<Todo> todos = snapshot.data ?? [];
                  if (todos.isEmpty) {
                    return const Center(
                      child: Text('Add a todo!'),
                    );
                  }
                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      Todo todo = todos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ListTile(
                          tileColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          title: Text(todo.title),
                          subtitle:
                              Text(DateFormat('dd-MM-yyyy hh:mm a').format(
                            todo.updatedOn.toDate(),
                          )),
                          trailing: Checkbox(
                            activeColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            value: todo.isDone,
                            onChanged: (value) {
                              setState(() {
                                todo.isDone = value!;
                                todo.updatedOn = Timestamp.now();
                                DatabaseServices().updateTodo(todo.id, todo);
                              });
                            },
                          ),
                          onLongPress: () {
                            setState(() {
                              _databaseServices.deleteTodo(todo.id);
                              _todos.remove(todo);
                            });
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewTodoScreen(todo: todo),
                                ));
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
