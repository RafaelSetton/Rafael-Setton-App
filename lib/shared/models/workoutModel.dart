import 'dart:convert';
import 'package:collection/collection.dart';

class ExerciseModel {
  final String title;
  final int duration;
  ExerciseModel({
    required this.title,
    required this.duration,
  });

  ExerciseModel copyWith({
    String? title,
    int? duration,
  }) {
    return ExerciseModel(
      title: title ?? this.title,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'duration': duration,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      title: map['title'] ?? '',
      duration: map['duration']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExerciseModel.fromJson(String source) =>
      ExerciseModel.fromMap(json.decode(source));

  @override
  String toString() => 'ExerciseModel(title: $title, duration: $duration)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExerciseModel &&
        other.title == title &&
        other.duration == duration;
  }

  @override
  int get hashCode => title.hashCode ^ duration.hashCode;
}

class WorkoutModel {
  final List<ExerciseModel> workouts;
  WorkoutModel({
    required this.workouts,
  });

  String toJson() => json.encode(workouts);

  factory WorkoutModel.fromJson(String source) {
    final List<ExerciseModel> exercises = (json.decode(source) as List)
        .map<ExerciseModel>((e) => ExerciseModel.fromMap(e))
        .toList();
    return WorkoutModel(workouts: exercises);
  }

  @override
  String toString() => 'WorkoutModel(workouts: $workouts)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is WorkoutModel && listEquals(other.workouts, workouts);
  }

  @override
  int get hashCode => workouts.hashCode;
}
