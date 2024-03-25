import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/chats_messages_area/chats%20area/chats_area.dart';
import 'package:whatsapp_web_clone/chats_messages_area/messages_area.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';
import 'package:whatsapp_web_clone/widgets/notification_dialog_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserModel userModel;
  String? _token;
  Stream<String>? _tokenStream;

  readCurrentUserData() async {
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

    await getPermisionForNotification();
    await pushNotificationMessageListener();

    ///for device token
    await FirebaseMessaging.instance.getToken().then(setTokenNow);

    ///for refresh token
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream!.listen(setTokenNow);

    await saveTokenToUserInfo();
  }

  ///for device permission
  getPermisionForNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  pushNotificationMessageListener() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (context) {
            return NotificationDialogWidget(
              title: message.notification!.title!,
              bodyText: message.notification!.body!,
            );
          },
        );
      }
    });
  }

  ///to set token in variable
  setTokenNow(String? token) {
    if (kDebugMode) {
      print("\n FCM user recognition token: $token \n");
    }
    setState(() {
      _token = token;
    });
  }

  ///save token to user inforamtion
  saveTokenToUserInfo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'token': _token,
    });
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
                    child: ChatsArea(
                      userModel: userModel,
                    ),
                  ),

                  ///message area
                  Expanded(
                    flex: 10,
                    child: MessagesArea(
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
