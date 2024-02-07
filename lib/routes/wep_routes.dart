// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/web_pages/home_page.dart';
import 'package:whatsapp_web_clone/web_pages/login_signup_page.dart';
import 'package:whatsapp_web_clone/web_pages/messages_page.dart';

class RoutesForWebPages {
  static Route<dynamic> createRoutes(RouteSettings routeSettings) {
    final argument = routeSettings.arguments;
    switch (routeSettings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => const LoginSignupPage());
      case "/home":
        return MaterialPageRoute(builder: (context) => const HomePage());
      case "/messages":
        return MaterialPageRoute(builder: (context) => const MessagesPage());

      default:
        return errorPageRoute();
    }
  }

  static Route<dynamic> errorPageRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Web page not found"),
        ),
        body: const Center(
          child: Text("Web page not found"),
        ),
      );
    });
  }
}
