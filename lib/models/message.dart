// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final String uid;
  final String text;
  final String dateTime;

  Message({required this.uid, required this.text, required this.dateTime});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'text': text,
      'dateTime': dateTime,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      uid: map['uid'] as String,
      text: map['text'] as String,
      dateTime: map['dateTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
