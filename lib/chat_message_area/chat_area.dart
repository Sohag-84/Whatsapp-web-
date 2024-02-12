import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

class ChatArea extends StatefulWidget {
  final UserModel userModel;
  const ChatArea({super.key, required this.userModel});

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: const BoxDecoration(
          color: DefaultColors.lightBarBackgroundColor,
          border: Border(
            right: BorderSide(
              color: DefaultColors.backgroundColor,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              color: DefaultColors.backgroundColor,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      widget.userModel.image.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.userModel.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushReplacementNamed(context, "/");
                      });
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
