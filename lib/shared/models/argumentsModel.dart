import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';

class ArgumentsModel {
  String userEmail;
  FirebaseApp firebaseApp;
  Object? argument;

  ArgumentsModel({
    required this.userEmail,
    required this.firebaseApp,
    this.argument,
  });

  ArgumentsModel copyWith({
    String? userEmail,
    FirebaseApp? firebaseApp,
    Object? argument,
  }) {
    return ArgumentsModel(
      userEmail: userEmail ?? this.userEmail,
      firebaseApp: firebaseApp ?? this.firebaseApp,
      argument: argument ?? this.argument,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'firebaseApp': firebaseApp,
      'argument': argument,
    };
  }

  factory ArgumentsModel.fromMap(Map<String, dynamic> map) {
    return ArgumentsModel(
      userEmail: map['userEmail'],
      firebaseApp: map['firebaseApp'],
      argument: map['argument'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ArgumentsModel.fromJson(String source) =>
      ArgumentsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ArgumentsModel(userEmail: $userEmail, firebaseApp: $firebaseApp, argument: $argument)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArgumentsModel &&
        other.userEmail == userEmail &&
        other.firebaseApp == firebaseApp &&
        other.argument == argument;
  }

  @override
  int get hashCode =>
      userEmail.hashCode ^ firebaseApp.hashCode ^ argument.hashCode;
}
