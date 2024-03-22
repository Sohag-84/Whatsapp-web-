import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/chat.dart';
import 'package:whatsapp_web_clone/models/message.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';
import 'package:whatsapp_web_clone/provider/provider_chat.dart';

class MessageWidget extends StatefulWidget {
  final UserModel fromUserModel;
  final UserModel toUserModel;
  const MessageWidget({
    super.key,
    required this.fromUserModel,
    required this.toUserModel,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final msgController = TextEditingController();

  late StreamSubscription _streamSubscriptionMessages;

  final streamController = StreamController<QuerySnapshot>.broadcast();

  ///for show last message of the list of message. auto scroll work here
  final scrollControllerMessages = ScrollController();
  String? fileTypeChoosed;

  sendMessage() {
    String msg = msgController.text.trim();
    if (msg.isNotEmpty) {
      ///this is the logged in user id
      String fromUserId = widget.fromUserModel.uid;
      final message = Message(
        uid: fromUserId,
        text: msg,
        dateTime: Timestamp.now().toString(),
      );

      ///another user
      String toUserId = widget.toUserModel.uid;

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
        toUserName: widget.toUserModel.name,
        toUserEmail: widget.toUserModel.email,
        toUserImage: widget.toUserModel.image,
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
        toUserName: widget.fromUserModel.name,
        toUserEmail: widget.fromUserModel.email,
        toUserImage: widget.fromUserModel.image,
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

  ///get message list
  createMessageListener({UserModel? toUserData}) {
    ///live refresh our messages page directly from firebase
    final streamMessages = FirebaseFirestore.instance
        .collection("messages")
        .doc(widget.fromUserModel.uid)
        .collection(toUserData?.uid ?? widget.toUserModel.uid)
        .orderBy("dateTime", descending: false)
        .snapshots();

    ///for scroll at the end of messages list
    _streamSubscriptionMessages = streamMessages.listen((data) {
      streamController.add(data);

      ///after 1 second auto scroll will be work here.
      Timer(const Duration(seconds: 1), () {
        scrollControllerMessages
            .jumpTo(scrollControllerMessages.position.maxScrollExtent);
      });
    });
  }

  updateMessageListener() {
    UserModel? toUserData = context.watch<ProviderChat>().toUser;

    if (toUserData != null) {
      createMessageListener(toUserData: toUserData);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///to update the message listener through provider
    updateMessageListener();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscriptionMessages.cancel();
  }

  @override
  void initState() {
    super.initState();
    createMessageListener();
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
          StreamBuilder(
            stream: streamController.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 5),
                          Text("Loading....")
                        ],
                      ),
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error occured"),
                    );
                  } else {
                    final data = snapshot.data as QuerySnapshot;
                    List<DocumentSnapshot> messageList = data.docs.toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: messageList.length,
                        itemBuilder: (context, index) {
                          final message = messageList[index];

                          ///align message balloons from sender and reciever
                          Alignment alignment = Alignment.bottomLeft;
                          Color color = Colors.white;
                          if (widget.fromUserModel.uid == message['uid']) {
                            alignment = Alignment.bottomRight;
                            color = const Color(0xFFd2ffa5);
                          }
                          Size width = MediaQuery.sizeOf(context) * 0.8;
                          return GestureDetector(
                            onDoubleTap: () {},
                            child: Align(
                              alignment: alignment,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.all(6),
                                constraints: BoxConstraints.loose(width),
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(message['text']),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                default:
                  return const Text("Error Occurred");
              }
            },
          ),

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

                        ///for send [file]
                        IconButton(
                          onPressed: () {
                            dialogBoxForSelectingFile();
                          },
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

  dialogBoxForSelectingFile() {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter stateSetter) {
          return AlertDialog(
            title: const Text("Send file"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Please choose file type from the following:"),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DropdownButton<String>(
                    hint: const Text("Choose here"),
                    value: fileTypeChoosed,
                    underline: Container(),
                    items: <String>[
                      ".pdf",
                      ".mp4",
                      ".mp3",
                      ".docx",
                      ".pptx",
                      ".xlsx"
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      stateSetter(() {
                        fileTypeChoosed = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Select file"),
              ),
            ],
          );
        });
      },
    );
  }
}
