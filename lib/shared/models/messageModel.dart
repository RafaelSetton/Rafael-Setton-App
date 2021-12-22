import 'dart:convert';

class MessageModel {
  final String senderEmail;
  final String chatID;
  final String content;
  late DateTime time;
  late String id;

  MessageModel({
    String? id,
    required this.senderEmail,
    required this.chatID,
    required this.content,
  }) {
    if (id == null) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      this.id = chatID + '-' + senderEmail + '@' + timestamp;
    } else {
      this.id = id;
    }
    this.time = DateTime.now();
  }

  MessageModel copyWith({
    String? senderEmail,
    String? chatID,
    String? content,
    DateTime? time,
    String? id,
  }) {
    return MessageModel(
      senderEmail: senderEmail ?? this.senderEmail,
      chatID: chatID ?? this.chatID,
      content: content ?? this.content,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'chatID': chatID,
      'content': content,
      'time': time,
      'id': id,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderEmail: map['senderEmail'],
      chatID: map['chatID'],
      content: map['content'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageModel(senderEmail: $senderEmail, chatID: $chatID, content: $content, time: $time, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.senderEmail == senderEmail &&
        other.chatID == chatID &&
        other.content == content &&
        other.time == time &&
        other.id == id;
  }

  @override
  int get hashCode {
    return senderEmail.hashCode ^
        chatID.hashCode ^
        content.hashCode ^
        time.hashCode ^
        id.hashCode;
  }
}
