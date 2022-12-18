class ScoreModel {
  DateTime dateTime;
  int right;
  int wrong;
  String? mode;
  ScoreModel({
    required this.dateTime,
    required this.right,
    required this.wrong,
    this.mode,
  });

  ScoreModel copyWith({
    DateTime? dateTime,
    int? right,
    int? wrong,
    String? mode,
  }) {
    return ScoreModel(
      dateTime: dateTime ?? this.dateTime,
      right: right ?? this.right,
      wrong: wrong ?? this.wrong,
      mode: mode ?? this.mode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "${dateTime.millisecondsSinceEpoch}": {
        'right': right,
        'wrong': wrong,
        'mode': mode,
      }
    };
  }

  factory ScoreModel.fromMap(int key, Map<String, dynamic> values) {
    return ScoreModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(key),
      right: values['right']?.toInt() ?? 0,
      wrong: values['wrong']?.toInt() ?? 0,
      mode: values['mode'],
    );
  }

  @override
  String toString() {
    return 'ScoreModel(dateTime: $dateTime, right: $right, wrong: $wrong, mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScoreModel &&
        other.dateTime == dateTime &&
        other.right == right &&
        other.wrong == wrong &&
        other.mode == mode;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^ right.hashCode ^ wrong.hashCode ^ mode.hashCode;
  }
}
