// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chat {
  final String fromUserId;
  final String toUserId;
  final String lastMessage;
  final String toUserName;
  final String toUserEmail;
  final String toUserImage;

  Chat({
    required this.fromUserId,
    required this.toUserId,
    required this.lastMessage,
    required this.toUserName,
    required this.toUserEmail,
    required this.toUserImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'lastMessage': lastMessage,
      'toUserName': toUserName,
      'toUserEmail': toUserEmail,
      'toUserImage': toUserImage,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      fromUserId: map['fromUserId'] as String,
      toUserId: map['toUserId'] as String,
      lastMessage: map['lastMessage'] as String,
      toUserName: map['toUserName'] as String,
      toUserEmail: map['toUserEmail'] as String,
      toUserImage: map['toUserImage'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}
