import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:sql_treino/shared/models/ToDoModel.dart';

class UserDataModel {
  List<ToDoModel> todos;
  List<String> chats;
  UserDataModel({
    required this.todos,
    required this.chats,
  });

  UserDataModel copyWith({
    List<ToDoModel>? todos,
    List<String>? chats,
  }) {
    return UserDataModel(
      todos: todos ?? this.todos,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'todos': todos.map((x) => x.toMap()).toList(),
      'chats': chats,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      todos:
          List<ToDoModel>.from(map['todos']?.map((x) => ToDoModel.fromMap(x))),
      chats: List<String>.from(map['chats']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source));

  @override
  String toString() => 'UserDataModel(todos: $todos, chats: $chats)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is UserDataModel &&
        listEquals(other.todos, todos) &&
        listEquals(other.chats, chats);
  }

  @override
  int get hashCode => todos.hashCode ^ chats.hashCode;
}
