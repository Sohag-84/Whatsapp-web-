import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';
import 'package:whatsapp_web_clone/widgets/messages_widget.dart';

class MessagesPage extends StatefulWidget {
  final UserModel toUserData;
  const MessagesPage({super.key, required this.toUserData});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late UserModel toUser;
  late UserModel fromUser;

  getUserData() {
    toUser = widget.toUserData;

    User? loggedInUser = FirebaseAuth.instance.currentUser;

    if (loggedInUser != null) {
      fromUser = UserModel(
        uid: loggedInUser.uid,
        name: loggedInUser.displayName ?? "",
        email: loggedInUser.email ?? "",
        password: "",
        image: loggedInUser.photoURL ?? "",
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DefaultColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(toUser.image),
            ),
            const SizedBox(width: 8),
            Text(
              toUser.name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.more_vert),
        ],
      ),
      body: MessageWidget(
        fromUserModel: fromUser,
        toUserModel: toUser,
      ),
    );
  }
}
