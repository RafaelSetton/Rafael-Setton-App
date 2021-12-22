import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:sql_treino/shared/models/messageModel.dart';

class ChatModel {
  String id;
  List<MessageModel> messages;
  List<String> users;
  String title;
  String? imgURL;

  ChatModel({
    required this.id,
    required this.messages,
    required this.users,
    required this.title,
    this.imgURL,
  });

  ChatModel copyWith({
    String? id,
    List<MessageModel>? messages,
    List<String>? users,
    String? title,
    String? imgURL,
  }) {
    return ChatModel(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      users: users ?? this.users,
      title: title ?? this.title,
      imgURL: imgURL ?? this.imgURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'messages': messages.map((x) => x.toMap()).toList(),
      'users': users,
      'title': title,
      'imgURL': imgURL,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      messages: List<MessageModel>.from(
          map['messages']?.map((x) => MessageModel.fromMap(x))),
      users: List<String>.from(map['users']),
      title: map['title'],
      imgURL: map['imgURL'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChatModel(id: $id, messages: $messages, users: $users, title: $title, imgURL: $imgURL)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel &&
        other.id == id &&
        listEquals(other.messages, messages) &&
        listEquals(other.users, users) &&
        other.title == title &&
        other.imgURL == imgURL;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        messages.hashCode ^
        users.hashCode ^
        title.hashCode ^
        imgURL.hashCode;
  }
}
