import 'package:sql_treino/shared/models/workoutModel.dart';

class WorkoutSetModel {
  List<WorkoutModel> workouts;

  WorkoutSetModel({required this.workouts});

  WorkoutSetModel.fromMapList(List<Map<String, dynamic>> data)
      : this.workouts = data.map((e) => WorkoutModel.fromMap(e)).toList();

  toMapList() => this.workouts.map((e) => e.toMap()).toList();
}
