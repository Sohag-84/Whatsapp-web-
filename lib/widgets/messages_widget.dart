import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
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
                  onPressed: () {},
                  mini: true,
                  backgroundColor: DefaultColors.primaryColor,
                  child: const Icon(Icons.send,color: Colors.white,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
