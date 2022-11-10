import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:sql_treino/shared/models/ToDoModel.dart';
import 'package:sql_treino/shared/models/workoutSetModel.dart';

class UserDataModel {
  int colorGamePts;
  List<ToDoModel> todos;
  List<String> chats;

  UserDataModel({
    required this.colorGamePts,
    required this.todos,
    required this.chats,
  });

  UserDataModel copyWith({
    int? colorGamePts,
    List<ToDoModel>? todos,
    List<String>? chats,
  }) {
    return UserDataModel(
      colorGamePts: colorGamePts ?? this.colorGamePts,
      todos: todos ?? this.todos,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'colorGamePts': colorGamePts,
      'todos': todos.map((x) => x.toMap()).toList(),
      'chats': chats,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      colorGamePts: map['colorGamePts']?.toInt() ?? 0,
      todos:
          List<ToDoModel>.from(map['todos']?.map((x) => ToDoModel.fromMap(x))),
      chats: List<String>.from(map['chats']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserDataModel(colorGamePts: $colorGamePts, todos: $todos, chats: $chats)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other is UserDataModel &&
        other.colorGamePts == colorGamePts &&
        collectionEquals(other.todos, todos) &&
        collectionEquals(other.chats, chats) &&
        collectionEquals(other.chats, chats);
  }

  @override
  int get hashCode =>
      colorGamePts.hashCode ^
      todos.hashCode ^
      chats.hashCode
}
