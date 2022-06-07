// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:social_media/auth_ui/signup.dart';

import '../auth_ui/auth.dart';

class Dp extends StatefulWidget {
  final String email, password, dob, name;
  static String id = "dp";

  const Dp(
      {Key? key,
      required this.email,
      required this.password,
      required this.dob,
      required this.name})
      : super(key: key);

  @override
  _DpState createState() => _DpState();
}

String error = "";
bool loading = false;
String name = "";

FirebaseAuth user = FirebaseAuth.instance;
DateTime selectedDate = DateTime.now();
TextEditingController username = TextEditingController();
TextEditingController bio = TextEditingController();

final Auth _auth = Auth();
final _formkey = GlobalKey<FormState>();

class _DpState extends State<Dp> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      final imageTemporary = File(image!.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Icon(
          FontAwesome.twitter,
          color: Colors.blue,
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: height / 1.2,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Pick a profile picture",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height / 50,
                ),
                const Text(
                  "Have  a favorite selfie? Upload it now",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: height / 10,
                ),
                image == null
                    ? Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              pickImage(ImageSource.gallery);
                            });
                          },
                          child: Container(
                              height: height / 4,
                              width: width / 4,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(
                                Icons.photo_camera,
                                size: 76,
                                color: Colors.blue,
                              )),
                        ),
                      )
                    : Center(
                        child: Stack(
                          children: [
                            Image.file(
                              image!,
                              fit: BoxFit.cover,
                              height: height / 5,
                              width: width / 5,
                            ),
                            SizedBox(
                              height: height / 5,
                              width: width / 5,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        image = null;
                                      });
                                    },
                                    icon:
                                        Icon(Icons.cancel, color: Colors.red)),
                              ),
                            ),
                          ],
                        ),
                      ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        SizedBox(
                            height: height / 8,
                            width: width / 1,
                            child: Input(
                                read: false,
                                controller: username,
                                obscure: false,
                                text: "username",
                                value: (val) {},
                                valid: (val) {
                                  if (val.isEmpty) {
                                    return "Please Enter your name";
                                  } else {
                                    return null;
                                  }
                                })),
                        SizedBox(
                            height: height / 8,
                            width: width / 1,
                            child: Input(
                                read: false,
                                controller: bio,
                                obscure: false,
                                text: "Bio",
                                value: (val) {},
                                valid: (val) {
                                  if (val.isEmpty) {
                                    return "Please Enter your name";
                                  } else {
                                    return null;
                                  }
                                })),
                      ],
                    )),
                Spacer(),
                Center(
                  child: SizedBox(
                    height: height / 15,
                    width: width / 3,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            if (image == null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(
                                        "Please supply an image",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    );
                                  });
                            } else {
                              setState(() {
                                loading = true;
                              });
                              if (loading) {
                                showDialog(
                                    barrierDismissible: false,
                                    barrierColor: Colors.white,
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    });
                              }
                              // ignore: avoid_print
                              print(image!.path.toString());
                              dynamic result = await _auth.signUp(
                                  email: widget.email,
                                  username: username.text,
                                  password: widget.password,
                                  dob: widget.dob,
                                  bio: bio.text,
                                  name: widget.name,
                                  image: image!,
                                  context: context);

                              loading = false;

                              if (loading == false) {
                                Navigator.pop(context);
                              }
                              if (user.currentUser!.uid.isNotEmpty) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            }
                          }
                        },
                        child: const Text("Sign up")),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
