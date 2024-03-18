import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

class MessagesArea extends StatelessWidget {
  final UserModel currentUserData;
  const MessagesArea({super.key, required this.currentUserData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      color: Colors.white,
      child: Center(
        child: Image.asset("assets/images/whatsapp.png"),
      ),
    );
  }
}
