import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_web_clone/models/user_model.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  String currentUserId = "";

  @override
  void initState() {
    super.initState();
    getCurrentFirebaseUser();
  }

  getCurrentFirebaseUser() {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      currentUserId = firebaseUser.uid;
    }
  }

  Future<List<UserModel>> readContactList() async {
    final userRef = FirebaseFirestore.instance.collection('users');
    QuerySnapshot allUserRecord = await userRef.get();

    List<UserModel> allUserList = [];
    for (DocumentSnapshot userRecord in allUserRecord.docs) {
      String uid = userRecord['uid'];

      ///user own data don't need to show in the contact list
      if (uid == currentUserId) {
        continue;
      }
      String name = userRecord['name'];
      String email = userRecord['email'];
      String password = userRecord['password'];
      String image = userRecord['image'];
      UserModel userData = UserModel(
        uid: uid,
        name: name,
        email: email,
        password: password,
        image: image,
      );
      allUserList.add(userData);
    }
    return allUserList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: readContactList(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Padding(
                padding: EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text("Contacts loading...."),
                    SizedBox(height: 10),
                    CircularProgressIndicator(),
                  ],
                ),
              );

            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error on contacts list"),
                );
              } else {
                List<UserModel>? userContactList = snapshot.data;
                if (userContactList != null) {
                  return userContactList.isEmpty
                      ? const Center(
                          child: Text("No contacts found!"),
                        )
                      : ListView.separated(
                          separatorBuilder: (context, index) {
                            return const Divider(
                              thickness: 0.3,
                              color: Colors.grey,
                            );
                          },
                          itemCount: userContactList.length,
                          itemBuilder: (context, index) {
                            UserModel contact = userContactList[index];
                            return ListTile(
                              onTap: () {},
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(contact.image),
                              ),
                              title: Text(
                                contact.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(9),
                            );
                          },
                        );
                } else {
                  return const Center(
                    child: Text("No contacts found"),
                  );
                }
              }

            default:
              throw Exception("Somethis is wrong");
          }
        });
  }
}
