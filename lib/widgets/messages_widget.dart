import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/chat.dart';
import 'package:whatsapp_web_clone/models/message.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

class MessageWidget extends StatelessWidget {
  final UserModel fromUserModel;
  final UserModel toUserModel;
  MessageWidget({
    super.key,
    required this.fromUserModel,
    required this.toUserModel,
  });

  final msgController = TextEditingController();

  sendMessage() {
    String msg = msgController.text.trim();
    if (msg.isNotEmpty) {
      ///this is the logged in user id
      String fromUserId = fromUserModel.uid;
      final message = Message(
        uid: fromUserId,
        text: msg,
        dateTime: Timestamp.now().toString(),
      );

      ///another user
      String toUserId = toUserModel.uid;

      ///for each message unique id
      String messageId = DateTime.now().microsecondsSinceEpoch.toString();

      ///save message for [sender]
      saveMessageToDatabase(
        fromUserId: fromUserId,
        toUserId: toUserId,
        message: message,
        messageId: messageId,
      );

      ///save message for recent chat [sender]
      final chatFromData = Chat(
        fromUserId: fromUserId,
        toUserId: toUserId,
        lastMessage: message.text.trim(),
        toUserName: toUserModel.name,
        toUserEmail: toUserModel.email,
        toUserImage: toUserModel.image,
      );

      ///now save recent chat to database
      saveRecentChatToDatabase(
        chat: chatFromData,
        messageText: msg,
      );

      ///save message for [reciever]
      saveMessageToDatabase(
        fromUserId: toUserId,
        toUserId: fromUserId,
        message: message,
        messageId: messageId,
      );

      ///save message for [recent] chat [reciever]
      final chatToData = Chat(
        fromUserId: toUserId,
        toUserId: fromUserId,
        lastMessage: message.text.trim(),
        toUserName: fromUserModel.name,
        toUserEmail: fromUserModel.email,
        toUserImage: fromUserModel.image,
      );

      ///now save [recent chat] to database
      saveRecentChatToDatabase(
        chat: chatToData,
        messageText: msg,
      );
    }
  }

  ///for save message
  saveMessageToDatabase({
    required String fromUserId,
    required String toUserId,
    required Message message,
    required String messageId,
  }) {
    FirebaseFirestore.instance
        .collection('messages')
        .doc(fromUserId)
        .collection(toUserId)
        .doc(messageId)
        .set(message.toMap());
    msgController.clear();
  }

  ///for save [recent chat] to database
  saveRecentChatToDatabase({required Chat chat, required String messageText}) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.fromUserId)
        .collection('lastMessage')
        .doc(chat.toUserId)
        .set(chat.toMap())
        .then((value) {
      ///send push notification
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          ///display user message
          const Spacer(),

          ///text field for sending message
          Container(
            padding: const EdgeInsets.all(8),
            color: DefaultColors.backgroundColor,
            child: Row(
              children: [
                ///text filed with two icon button
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.insert_emoticon),
                        const SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: msgController,
                            decoration: const InputDecoration(
                              hintText: "Write a message",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.attach_file),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt),
                        ),
                      ],
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    sendMessage();
                  },
                  mini: true,
                  backgroundColor: DefaultColors.primaryColor,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
