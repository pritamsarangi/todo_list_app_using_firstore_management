import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoslist/Widgets/common_button_widget.dart';
import 'package:todoslist/models/todo_list.dart';
import 'package:todoslist/services/database_services.dart';

import '../Widgets/common_textfield_widget.dart';

class NewTodoScreen extends StatelessWidget {
  final Todo? todo;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  NewTodoScreen({Key? key, this.todo}) : super(key: key) {
    if (todo != null) {
      _titleController.text = todo!.title;
      _descriptionController.text = todo!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todo != null ? 'Edit Todo' : 'New Todo'),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonTextField(controller: _titleController, labelText: 'Title'),
              SizedBox(height: 16),
              CommonTextField(
                  controller: _descriptionController, labelText: 'Description'),
              SizedBox(height: 32),
              CommonButton(
                text: 'Save',
                onPressed: () {
                  if (todo != null) {
                    // Logic to update the todo
                    todo!.title = _titleController.text;
                    todo!.description = _descriptionController.text;
                    todo!.updatedOn = Timestamp.now();
                    DatabaseServices().updateTodo(todo!.id, todo!);
                  } else {
                    // Logic to add a new todo
                    String id = FirebaseFirestore.instance.collection('todos').doc().id;
                    Todo newTodo = Todo(
                      id: id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      isDone: false,
                      createdOn: Timestamp.now(),
                      updatedOn: Timestamp.now(),
                    );
                    DatabaseServices().addTodo(newTodo);
                  }
                  Navigator.pop(context); // Return to previous screen
                },
                child: Text(todo != null ? 'Update' : 'Save'),
               )
            ],
          )),
    );
  }
}
