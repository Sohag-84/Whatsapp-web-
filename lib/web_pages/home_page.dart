import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              child: const Row(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
