import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/default_color/default_colors.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

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

  ///for pick image
  chooseImage() async {
    FilePickerResult? chooseImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);

    setState(() {
      selectedImage = chooseImageFile!.files.single.bytes;
    });
  }

  ///upload image in the database
  uploadImageToStorage({required UserModel userData}) {
    if (selectedImage != null) {
      Reference imageRef =
          FirebaseStorage.instance.ref("Profileimages${userData.uid}.jpg");
      UploadTask uploadTask = imageRef.putData(selectedImage!);
      uploadTask.whenComplete(() async {
        String urlImage = await uploadTask.snapshot.ref.getDownloadURL();
        userData.image = urlImage;

        ///3.-->save user data to firebase database
        await FirebaseAuth.instance.currentUser!
            .updateDisplayName(userData.name);
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(urlImage);

        final userReference = FirebaseFirestore.instance.collection("users");
        userReference.doc(userData.uid).set(userData.toMap()).then((value) {
          setState(() {
            loadingOn = false;
            Navigator.pushReplacementNamed(context, "/home");
          });
        });
      });
    } else {
      var snackBar = const SnackBar(
        content: Center(child: Text("Please select image first!")),
        backgroundColor: DefaultColors.primaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  ///for user signup
  signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    ///1.--> create new user in firebase authentication
    final userCreated =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    ///2.--> upload profile image to storage
    String? uid = userCreated.user!.uid;
    final userData =
        UserModel(uid: uid, name: name, email: email, password: password);
    uploadImageToStorage(userData: userData);
  }

  ///for form validation || login & registration
  formValidation() async {
    setState(() {
      loadingOn = true;
      errorInPicture = false;
      errorInEmail = false;
      errorInName = false;
      errorInPassword = false;
    });

    String nameInput = nameController.text.trim();
    String emailInput = emailController.text.trim();
    String passwordInput = passwordController.text.trim();

    if (emailInput.isNotEmpty && emailInput.contains("@")) {
      if (passwordInput.isNotEmpty && passwordInput.length > 7) {
        ///signup form
        if (doesUserWantoSignup == true) {
          if (nameInput.isNotEmpty && nameInput.length >= 3) {
            signupUser(
              name: nameInput,
              email: emailInput,
              password: passwordInput,
            );
          } else {
            var snackBar = const SnackBar(
              content: Center(
                child: Text("Username must be at least 3 characters"),
              ),
              backgroundColor: DefaultColors.primaryColor,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          ///login form
        }
      } else {
        var snackBar = const SnackBar(
          content: Center(child: Text("Password is not valid")),
          backgroundColor: DefaultColors.primaryColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          loadingOn = false;
        });
      }
    } else {
      var snackBar = const SnackBar(
        content: Center(child: Text("Email is not valid")),
        backgroundColor: DefaultColors.primaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        loadingOn = false;
      });
    }
  }

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
                              onPressed: chooseImage,
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

                          ///login register button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: formValidation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DefaultColors.primaryColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: loadingOn
                                    ? const SizedBox(
                                        height: 25,
                                        width: 25,
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
