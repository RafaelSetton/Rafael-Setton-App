import 'dart:convert';

import 'package:sql_treino/shared/models/userDataModel.dart';

class UserModel {
  final String name;
  final String email;
  final String password;
  final String birthday;
  final UserDataModel data;
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
    UserDataModel? data,
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
      'data': data.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      birthday: map['birthday'],
      data: UserDataModel.fromMap(map['data']),
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
        other.data == data;
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
