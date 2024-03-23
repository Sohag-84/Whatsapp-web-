import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';
import 'package:whatsapp_web_clone/provider/provider_chat.dart';

class RecentChats extends StatefulWidget {
  const RecentChats({super.key});

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  late UserModel fromUserData;
  final streamController = StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription streamSubscriptionChats;

  chatListener() {
    final streamRecentChat = FirebaseFirestore.instance
        .collection('chats')
        .doc(fromUserData.uid)
        .collection('lastMessage')
        .snapshots();

    streamSubscriptionChats = streamRecentChat.listen((newMessage) {
      streamController.add(newMessage);
    });
  }

  loadInitialData() {
    User? currentFirebaseUser = FirebaseAuth.instance.currentUser;

    if (currentFirebaseUser != null) {
      String userId = currentFirebaseUser.uid;
      String? name = currentFirebaseUser.displayName ?? "";
      String? email = currentFirebaseUser.email ?? "";
      String password = "";
      String? photo = currentFirebaseUser.photoURL ?? "";

      fromUserData = UserModel(
        uid: userId,
        name: name,
        email: email,
        password: password,
        image: photo,
      );
    }
    chatListener();
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscriptionChats.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Column(
              children: [
                Text("Loading chat..."),
                SizedBox(height: 5),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else {
          return ListView.separated(
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.grey,
                thickness: 0.3,
              );
            },
            itemBuilder: (context, index) {
              final chat = snapshot.data!.docs[index];
              String toUserImage = chat['toUserImage'];
              String toUserName = chat['toUserName'];
              String toUserEmail = chat['toUserEmail'];
              String lastMessage = chat['lastMessage'];
              String toUserId = chat['toUserId'];
              final toUserData = UserModel(
                uid: toUserId,
                name: toUserName,
                email: toUserEmail,
                password: '',
                image: toUserImage,
              );
              return ListTile(
                onTap: () {
                  context.read<ProviderChat>().toUserData = toUserData;
                },
                leading: CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(toUserData.image),
                ),
                title: Text(
                  toUserData.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  lastMessage.contains('.jpg')
                      ? "sent you an image"
                      : lastMessage.contains('.pdf') ||
                              lastMessage.contains('.mp4') ||
                              lastMessage.contains('.mp3') ||
                              lastMessage.contains('.docx') ||
                              lastMessage.contains('.pptx') ||
                              lastMessage.contains('.xlsx')
                          ? "sent you a file"
                          : lastMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                contentPadding: const EdgeInsets.all(6),
              );
            },
          );
        }
      },
    );
  }
}
