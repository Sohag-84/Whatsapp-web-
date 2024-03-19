import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/provider/provider_chat.dart';
import 'package:whatsapp_web_clone/routes/web_routes.dart';

String firstRoute = "/";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCGvkqSuQh9m3kTENVVTQ7hdppEjHEFRs4",
    authDomain: "whatsapp-web-clone-a29aa.firebaseapp.com",
    projectId: "whatsapp-web-clone-a29aa",
    storageBucket: "whatsapp-web-clone-a29aa.appspot.com",
    messagingSenderId: "581397415635",
    appId: "1:581397415635:web:a4d2a5df38f0cfcb8d3626",
  ));
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    firstRoute = "/home";
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProviderChat(),
      child: const MyApp(),
    ),
  );
}

final ThemeData defaultThemeOfWebApp = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: DefaultColors.primaryColor),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whatsapp web clone',
      debugShowCheckedModeBanner: false,
      theme: defaultThemeOfWebApp,
      initialRoute: firstRoute,
      onGenerateRoute: RoutesForWebPages.createRoutes,
    );
  }
}
