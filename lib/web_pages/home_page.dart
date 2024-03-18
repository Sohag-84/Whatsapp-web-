import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/chat_message_area/chat_area.dart';
import 'package:whatsapp_web_clone/chat_message_area/message_area.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel userModel;

  readCurrentUserData() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      String name = currentUser.displayName ?? "";
      String email = currentUser.email ?? "";
      String password = "";
      String image = currentUser.photoURL ?? "";

      userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        password: password,
        image: image,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    readCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: DefaultColors.lightBarBackgroundColor,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                color: DefaultColors.primaryColor,
                height: MediaQuery.sizeOf(context).height * 0.2,
                width: MediaQuery.sizeOf(context).width,
              ),
            ),
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.05,
              bottom: MediaQuery.sizeOf(context).height * 0.05,
              left: MediaQuery.sizeOf(context).height * 0.05,
              right: MediaQuery.sizeOf(context).height * 0.05,
              child: Row(
                children: [
                  ///chat area
                  Expanded(
                    flex: 4,
                    child: ChatArea(
                      userModel: userModel,
                    ),
                  ),

                  ///message area
                  Expanded(
                    flex: 10,
                    child: MessageArea(
                      currentUserData: userModel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
