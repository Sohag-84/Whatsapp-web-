import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool doesUserWantoSignup = false;
  Uint8List? selectedImage;
  bool errorInPicture = false;
  bool errorInName = false;
  bool errorInEmail = false;
  bool errorInPassword = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loadingOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: DefaultColors.backgroundColor,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.5,
                color: DefaultColors.primaryColor,
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      width: 500,
                      child: Column(
                        children: [
                          ///profile image
                          Visibility(
                            visible: doesUserWantoSignup,
                            child: ClipOval(
                              child: selectedImage != null
                                  ? Image.memory(
                                      selectedImage!,
                                      width: 124,
                                      height: 124,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "assets/images/avatar.png",
                                      width: 124,
                                      height: 124,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          ///choose image button
                          Visibility(
                            visible: doesUserWantoSignup,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: errorInPicture
                                  ? OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.red,
                                        width: 3,
                                      ),
                                    )
                                  : null,
                              child: const Text("Choose Picture"),
                            ),
                          ),
                          const SizedBox(height: 9),

                          ///name textfield
                          Visibility(
                            visible: doesUserWantoSignup,
                            child: TextField(
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Write valid a name",
                                labelText: "Name",
                                suffixIcon: const Icon(Icons.person),
                                enabledBorder: errorInName
                                    ? const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                          width: 3,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),

                          ///email textfield
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Write a valid email",
                              labelText: "Email",
                              suffixIcon:
                                  const Icon(Icons.mail_outline_outlined),
                              enabledBorder: errorInEmail
                                  ? const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 3,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 5),

                          ///password textfield
                          TextField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: doesUserWantoSignup
                                  ? "Password must be greater than 7 characters"
                                  : "Write your password",
                              labelText: "Password",
                              suffixIcon:
                                  const Icon(Icons.lock_outline_rounded),
                              enabledBorder: errorInPassword
                                  ? const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 3,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),

                          ///login regester button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DefaultColors.primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: loadingOn
                                    ? const SizedBox(
                                        height: 19,
                                        width: 19,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        doesUserWantoSignup
                                            ? "Sign Up"
                                            : "Login",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          ///toggle button
                          Row(
                            children: [
                              Text(
                                "Login",
                                style: doesUserWantoSignup
                                    ? null
                                    : const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                              ),
                              const SizedBox(width: 5),
                              Switch(
                                value: doesUserWantoSignup,
                                onChanged: (bool value) {
                                  setState(() {
                                    doesUserWantoSignup = value;
                                  });
                                },
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Signup",
                                style: doesUserWantoSignup
                                    ? const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
