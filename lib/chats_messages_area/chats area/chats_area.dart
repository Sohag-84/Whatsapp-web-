import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/chats_messages_area/chats%20area/contacts_list.dart';
import 'package:whatsapp_web_clone/chats_messages_area/chats%20area/recent_chats.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

class ChatsArea extends StatefulWidget {
  final UserModel userModel;
  const ChatsArea({super.key, required this.userModel});

  @override
  State<ChatsArea> createState() => _ChatsAreaState();
}

class _ChatsAreaState extends State<ChatsArea> {
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
            ///header
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
            ),
            const SizedBox(height: 5),

            ///tabs button
            const TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              indicatorColor: DefaultColors.primaryColor,
              indicatorWeight: 2,
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Text("Recent Chats"),
                Text("Contacts"),
              ],
            ),
            Expanded(
              child: Container(
                color: DefaultColors.backgroundColor,
                child: const TabBarView(
                  children: [
                    ///show recent chats
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: RecentChats(),
                    ),

                    ///show contacts list
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ContactsList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
