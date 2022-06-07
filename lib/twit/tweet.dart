// ignore_for_file: library_private_types_in_public_api, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/component/loader.dart';

import 'model_tweet.dart';

class Tweet extends StatefulWidget {
  static String id = "tweet";

  const Tweet({Key? key}) : super(key: key);

  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  late String username, name;
  String dp = "";
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getdata();
    super.initState();
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController post = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image != null) {
        final imageTemporary = File(image.path);
        setState(() {
          this.image = imageTemporary;
        });
      }
    } on PlatformException catch (e) {}
  }

  getdata() {
    final uid = _auth.currentUser!.uid;
    _firestore.collection("Users").doc(uid).get().then((value) {
      setState(() {
        final data = value.data()!;
        username = data["username"];
        name = data["name"];
        dp = data["dp"];
      });
    });
  }

  final Tweets tweet = Tweets();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      tweet.tweet(
                          context: context,
                          post: post.text,
                          username: username,
                          name: name,
                          dp: dp,
                          image: image);
                      Navigator.pushNamed(context, Progress.id);
                    }
                  },
                  child: const Text("Tweet")),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: height / 15,
              ),
              image != null
                  ? Stack(
                      children: [
                        Image.file(
                          image!,
                          fit: BoxFit.cover,
                          height: 160,
                          width: 160,
                        ),
                        Positioned(
                          bottom: 120,
                          left: 126,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  image = null;
                                });
                              },
                              icon: const Icon(Icons.cancel)),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(dp),
                    radius: 35,
                  ),
                  SizedBox(
                    height: height / 10,
                    width: width / 1.5,
                    child: Form(
                      key: _formkey,
                      child: TextFormField(
                          controller: post,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Empty Field";
                            }
                          },
                          decoration: const InputDecoration(
                              hintText: "What's happening?",
                              hintStyle: TextStyle(fontSize: 23))),
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.blue),
                      primary: Colors.white,
                      elevation: 0),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                  leading: const Icon(
                                    Icons.browse_gallery,
                                    color: Colors.blue,
                                  ),
                                  title: const Text("Gallery"),
                                  onTap: () {
                                    pickImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  }),
                              ListTile(
                                leading: const Icon(
                                  Icons.camera,
                                  color: Colors.blue,
                                ),
                                title: const Text("Camera"),
                                onTap: () {
                                  pickImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.blue,
                  ),
                  label: const Text(
                    " image",
                    style: TextStyle(color: Colors.blue),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
