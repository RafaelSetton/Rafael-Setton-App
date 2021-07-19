import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String birthday;
  final Map data;
  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.birthday,
    required this.data,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? birthday,
    Map? data,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      birthday: birthday ?? this.birthday,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'birthday': birthday,
      'data': data,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      birthday: map['birthday'],
      data: Map.from(map['data']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, password: $password, birthday: $birthday, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.birthday == birthday &&
        mapEquals(other.data, data);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        birthday.hashCode ^
        data.hashCode;
  }
}
