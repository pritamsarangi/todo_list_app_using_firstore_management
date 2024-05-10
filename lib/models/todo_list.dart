import 'package:cloud_firestore/cloud_firestore.dart';


class Todo {
  late String id;
  late String title;
  late String description;
  late bool isDone;
  late Timestamp createdOn;
  late Timestamp updatedOn;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdOn,
    required this.updatedOn,
  });

  Todo.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      id = json['id'] ?? '';
      title = json['title'] ?? '';
      description = json['description'] ?? '';
      isDone = json['isDone'] ;
      createdOn = json['createdOn'] ?? Timestamp.now();
      updatedOn = json['updatedOn'] ?? Timestamp.now();
    } else {
      // Handle the case where json is null
      // For example, throw an error or set default values
      id = '';
      title = '';
      description = '';
      isDone = false;
      createdOn = Timestamp.now();
      updatedOn = Timestamp.now();
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }

  Todo copyWith({
    String ? id,
    String ? title,
    String ? description,
    bool ? isDone,
    Timestamp ? createdOn,
    Timestamp ? updatedOn,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class Todo {
//   String task;
//   bool isDone;
//   Timestamp createdOn;
//   Timestamp updatedOn;
//
//   Todo({
//     required this.task,
//     required this.isDone,
//     required this.createdOn,
//     required this.updatedOn,
//   });
//
//   Todo.formJson(Map<String, Object?> json)
//       : this(
//     task: json['task']! as String,
//     isDone: json['isDone']! as bool,
//     createdOn: json['createdOn']! as Timestamp,
//     updatedOn: json['updatedOn']! as Timestamp,
//   );
//
//   Todo copyWith({
//     String? task,
//     bool? isDone,
//     Timestamp? createdOn,
//     Timestamp? updatedOn,
//   }) {
//     return Todo(task: task ?? this.task,
//         isDone: isDone ?? this.isDone,
//         createdOn: createdOn ?? this.createdOn,
//         updatedOn: updatedOn ?? this.updatedOn);
//   }
//
//   Map<String, Object?> toJson() {
//     return {
//       'task': task,
//       'isDone': isDone,
//       'createdOn': createdOn,
//       'updatedOn': updatedOn,
//     };
//   }
// }