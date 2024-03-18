import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';
import 'package:whatsapp_web_clone/provider/provider_chat.dart';
import 'package:whatsapp_web_clone/widgets/messages_widget.dart';

class MessagesArea extends StatelessWidget {
  final UserModel currentUserData;
  const MessagesArea({super.key, required this.currentUserData});

  @override
  Widget build(BuildContext context) {
    UserModel? toUserData = context.watch<ProviderChat>().toUser;
    return toUserData == null
        ? Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            color: Colors.white,
            child: Center(
              child: Image.asset("assets/images/whatsapp.png"),
            ),
          )
        : Column(
            children: [
              ///header
              Container(
                padding: const EdgeInsets.all(8),
                color: DefaultColors.barBackgroundColor,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(toUserData.image),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      toUserData.name,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    const Icon(Icons.search),
                    const Icon(Icons.more_vert),
                  ],
                ),
              ),

              ///message list
              Expanded(
                child: MessageWidget(
                  fromUserModel: currentUserData,
                  toUserModel: toUserData,
                ),
              ),
            ],
          );
  }
}
