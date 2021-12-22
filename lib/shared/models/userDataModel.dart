import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:sql_treino/shared/models/ToDoModel.dart';
import 'package:sql_treino/shared/models/workoutSetModel.dart';

class UserDataModel {
  int colorGamePts;
  List<ToDoModel> todos;
  Map<String, WorkoutSetModel> workouts;
  List<String> chats;

  UserDataModel({
    required this.colorGamePts,
    required this.todos,
    required this.workouts,
    required this.chats,
  });

  UserDataModel copyWith({
    int? colorGamePts,
    List<ToDoModel>? todos,
    Map<String, WorkoutSetModel>? workouts,
    List<String>? chats,
  }) {
    return UserDataModel(
      colorGamePts: colorGamePts ?? this.colorGamePts,
      todos: todos ?? this.todos,
      workouts: workouts ?? this.workouts,
      chats: chats ?? this.chats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'colorGamePts': colorGamePts,
      'todos': todos.map((x) => x.toMap()).toList(),
      'workouts':
          workouts.map((key, value) => MapEntry(key, value.toMapList())),
      'chats': chats,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      colorGamePts: map['colorGamePts'],
      todos:
          List<ToDoModel>.from(map['todos']?.map((x) => ToDoModel.fromMap(x))),
      workouts: Map<String, List>.from(map['workouts']).map((key, value) =>
          MapEntry(
              key,
              WorkoutSetModel.fromMapList(
                  List<Map<String, dynamic>>.from(value)))),
      chats: List<String>.from(map['chats']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserDataModel(colorGamePts: $colorGamePts, todos: $todos, workouts: $workouts, chats: $chats)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other is UserDataModel &&
        other.colorGamePts == colorGamePts &&
        collectionEquals(other.todos, todos) &&
        collectionEquals(other.workouts, workouts) &&
        collectionEquals(other.chats, chats);
  }

  @override
  int get hashCode =>
      colorGamePts.hashCode ^
      todos.hashCode ^
      workouts.hashCode ^
      chats.hashCode;
}
