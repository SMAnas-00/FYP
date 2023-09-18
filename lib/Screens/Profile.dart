import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  File? image;
  final picker = ImagePicker();
  String imageUrl = ' ';
  String username = "";

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  displayMessage(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
  }

  Future<void> setProfile() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    final user = auth.currentUser;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('/profiledp/${DateTime.now().millisecondsSinceEpoch}');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
      firestore
          .collection("app")
          .doc("Users")
          .collection("Signup")
          .doc(user?.uid)
          .update({'dp': imageUrl.toString()});
      displayMessage("Profile uploaded successfully");
    }).onError((error, stackTrace) {
      displayMessage(error.toString());
    });
  }

  Future<String> getProfileImage() async {
    final uid = auth.currentUser?.uid;
    final users = await firestore
        .collection("app")
        .doc("Users")
        .collection("Signup")
        .doc(uid)
        .get();
    return users.data()?['dp'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff3a57e8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xffffffff),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    FutureBuilder(
                        future: getProfileImage(),
                        builder: (_, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircleAvatar(
                              backgroundColor: Color(0xff3a57e8),
                            );
                          }
                          if (snapshot.data == "") {
                            return Container(
                              height: 120,
                              width: 120,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            );
                          }
                          return Container(
                            height: 120,
                            width: 120,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(snapshot.data.toString(),
                                fit: BoxFit.cover),
                          );
                        }),
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(0),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Color(0xff3a57e8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_camera,
                          color: Color(0xffffffff),
                          size: 20,
                        ),
                      ),
                      onTap: () {
                        setProfile();
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                  stream: firestore
                      .collection("app")
                      .doc("Users")
                      .collection("Signup")
                      .doc(auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                      child: ListTile(
                        tileColor: const Color(0x00ffffff),
                        title: const Text(
                          "Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff424141),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        subtitle: Text(
                          snapshot.data?["Last_name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 16,
                            color: Color(0xff000000),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        dense: true,
                        contentPadding: const EdgeInsets.all(0),
                        selected: false,
                        selectedTileColor: const Color(0x42000000),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        leading: const Icon(Icons.person,
                            color: Color(0xff3a57e8), size: 24),
                        trailing: const Icon(Icons.edit,
                            color: Color(0xff79797c), size: 22),
                      ),
                    );
                  }),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 0, 0),
                child: Text(
                  "This is not your username or pin. This name will be visible to your Palmer Profile.",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                    color: Color(0xff000000),
                  ),
                ),
              ),
              const Divider(
                color: Color(0xffdddddd),
                height: 30,
                thickness: 0,
                indent: 50,
                endIndent: 0,
              ),
              StreamBuilder(
                  stream: firestore
                      .collection("app")
                      .doc("Users")
                      .collection("Signup")
                      .doc(auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListTile(
                      tileColor: const Color(0x00ffffff),
                      title: const Text(
                        "ID",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Text(
                        snapshot.data?['id'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                      selected: false,
                      selectedTileColor: const Color(0x42000000),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      leading: const Icon(Icons.info_outline,
                          color: Color(0xff3a57e8), size: 24),
                    );
                  }),
              const Divider(
                color: Color(0xffdddddd),
                height: 30,
                thickness: 0,
                indent: 50,
                endIndent: 0,
              ),
              StreamBuilder(
                  stream: firestore
                      .collection("app")
                      .doc("Users")
                      .collection("Signup")
                      .doc(auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListTile(
                      tileColor: const Color(0x00ffffff),
                      title: const Text(
                        "Citizen Card:",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Text(
                        snapshot.data?['cnic'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 12,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                      selected: false,
                      selectedTileColor: const Color(0x42000000),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      leading: const Icon(Icons.contact_emergency_outlined,
                          color: Color(0xff3a57e8), size: 24),
                    );
                  }),
              const Divider(
                color: Color(0xffdddddd),
                height: 20,
                thickness: 0,
                indent: 50,
                endIndent: 0,
              ),
              StreamBuilder(
                  stream: firestore
                      .collection("app")
                      .doc("Users")
                      .collection("Signup")
                      .doc(auth.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListTile(
                      tileColor: const Color(0x00ffffff),
                      title: const Text(
                        "Phone",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      subtitle: Text(
                        snapshot.data?['Contact'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                          color: Color(0xff000000),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                      selected: false,
                      selectedTileColor: const Color(0x42000000),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      leading: const Icon(Icons.call,
                          color: Color(0xff3a57e8), size: 24),
                    );
                  }),
              const Divider(
                  color: Color(0xffdddddd),
                  height: 20,
                  thickness: 0,
                  indent: 50,
                  endIndent: 0),
              GestureDetector(
                onTap: () => _showConfirmLogout(),
                child: const ListTile(
                  tileColor: Color(0x00ffffff),
                  title: Text(
                    "SIGNOUT",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xff000000),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  selected: false,
                  selectedTileColor: Color(0x42000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  leading:
                      Icon(Icons.output, color: Color(0xff3a57e8), size: 24),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  _showConfirmLogout() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        message: const Text("Would you like to log out?"),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              auth
                  .signOut()
                  .then((value) => Navigator.pop(context))
                  .then((value) => Navigator.pushNamed(context, '/signin'));
            },
            child: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
