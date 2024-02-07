import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/routes/wep_routes.dart';

String firstRoute = "/";

void main() {
  runApp(const MyApp());
}

final ThemeData defaultThemeOfWebApp = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: DefaultColors.primaryColor),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: defaultThemeOfWebApp,
      initialRoute: firstRoute,
      onGenerateRoute: RoutesForWebPages.createRoutes,
    );
  }
}
