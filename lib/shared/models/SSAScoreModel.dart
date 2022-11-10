class SSAScoreModel {
  DateTime dateTime;
  int right;
  int wrong;
  String mode;
  SSAScoreModel({
    required this.dateTime,
    required this.right,
    required this.wrong,
    required this.mode,
  });

  SSAScoreModel copyWith({
    DateTime? dateTime,
    int? right,
    int? wrong,
    String? mode,
  }) {
    return SSAScoreModel(
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

  factory SSAScoreModel.fromMap(int key, Map<String, dynamic> values) {
    return SSAScoreModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(key),
      right: values['right']?.toInt() ?? 0,
      wrong: values['wrong']?.toInt() ?? 0,
      mode: values['mode'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Score(dateTime: $dateTime, right: $right, wrong: $wrong, mode: $mode)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SSAScoreModel &&
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
