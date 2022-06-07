// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/component/loader.dart';
import 'package:social_media/twit/Profile/plikes..dart';
import 'package:social_media/twit/Profile/ptweets.dart';

class Profile extends StatefulWidget {
  static String id = "profile";

  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getdata();
    fifi();
  }

  var username, name, tweets, val, joined, bio, dp, followers, following;
  List<String> fiyin = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //This is for when you don't want to use sspecifed

  get() {
    final uid = _auth.currentUser!.uid;
    _firestore.collection("Tweets").get().then((value) {
      value.docs.forEach((e) {
        setState(() {
          if (_auth.currentUser!.uid == e.get("uid")) {
            e.data()["uid"];
            fiyin.add(e.data()["uid"]);
          } else {
            // print(e.get("uid"));
          }
        });
      });
    }).asStream();
  }

  getdata() {
    final uid = _auth.currentUser!.uid;

    _firestore.collection("Users").doc(uid).get().then((value) {
      setState(() {
        final data = value.data()!;
        username = data["username"];
        name = data["name"];
        bio = data["bio"];
        dp = data["dp"];
        joined = data["joined"];
        followers = data["followers"];
        following = data["following"];
        // tweets = data["tweets"].length;
      });
    });

    // _firestore.collection("Tweets").get().then((value) {
    //   value.docs.forEach((e) {
    //     // print(e.data()["uid"]);
    //     // print(e.get("uid"));

    //     // print(e.id);
    //     // print(e.id);
    //     // if (_auth.currentUser!.uid == e.data()["uid"]) {
    //     //   print(fiyin);
    //     // }
    //   });
    // });
  }

  fifi() {
    _firestore.collection("Tweets").snapshots().forEach((e) {
      e.docs.forEach((e) {
        if (_auth.currentUser!.uid == e.get("uid")) {
          e.data()["uid"];
          fiyin.add(e.data()["uid"]);
        } else {
          // print(e.get("uid"));
        }
      });
    }).asStream();

    
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return username == null
        ? Progress()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.blueGrey.shade50,
              title: ListTile(
                title: Text(name),
                subtitle: Text("${fiyin.length.toString()} Tweets"),
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: SizedBox(
              height: height,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: height / 10,
                          width: width,
                          decoration:
                              BoxDecoration(color: Colors.blueGrey.shade200),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 32.0, left: 20.0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(dp),
                            ))
                      ],
                    ),
                    ListTile(
                      title: Text(name),
                      subtitle: Text("@ ${username}"),
                      trailing: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        child: OutlinedButton(
                            onPressed: () {
                              get();
                            },
                            child: const Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(bio),
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month),
                          SizedBox(
                            width: width / 20,
                          ),
                          Text("Joined $joined",
                              style: const TextStyle(color: Colors.grey))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text("${following.length}"),
                              SizedBox(
                                width: width / 40,
                              ),
                              const Text("Following",
                                  style: TextStyle(color: Colors.grey)),
                              const SizedBox(
                                width: 29,
                              ),
                              Row(
                                children: [
                                  Text("${followers.length}"),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                  const Text(
                                    "Followers",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 19,
                    ),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            padding: EdgeInsets.only(),
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            tabs: [
                              Tab(
                                text: "Tweets",
                              ),
                              Tab(
                                text: "Likes",
                              )
                            ],
                          ),
                          SizedBox(
                            height: height,
                            width: width,
                            child:
                                const TabBarView(children: [Ptweet(), Likes()]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
