import 'dart:convert';

class WorkoutModel {
  String title;
  int duration;
  WorkoutModel({
    required this.title,
    required this.duration,
  });

  WorkoutModel copyWith({
    String? title,
    int? duration,
  }) {
    return WorkoutModel(
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

  factory WorkoutModel.fromMap(Map<String, dynamic> map) {
    return WorkoutModel(
      title: map['title'],
      duration: map['duration'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkoutModel.fromJson(String source) =>
      WorkoutModel.fromMap(json.decode(source));

  @override
  String toString() => 'WorkoutModel(title: $title, duration: $duration)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkoutModel &&
        other.title == title &&
        other.duration == duration;
  }

  @override
  int get hashCode => title.hashCode ^ duration.hashCode;
}
