import 'dart:convert';

class ToDoModel {
  final String title;
  bool ok;
  ToDoModel({
    required this.title,
    required this.ok,
  });

  ToDoModel copyWith({
    String? title,
    bool? ok,
  }) {
    return ToDoModel(
      title: title ?? this.title,
      ok: ok ?? this.ok,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ok': ok,
    };
  }

  factory ToDoModel.fromMap(Map<String, dynamic> map) {
    return ToDoModel(
      title: map['title'],
      ok: map['ok'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ToDoModel.fromJson(String source) =>
      ToDoModel.fromMap(json.decode(source));

  @override
  String toString() => 'ToDoModel(title: $title, ok: $ok)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ToDoModel && other.title == title && other.ok == ok;
  }

  @override
  int get hashCode => title.hashCode ^ ok.hashCode;
}
