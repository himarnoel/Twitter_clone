import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/nav/dp.dart';

import '../auth_ui/auth.dart';
import '../twit/Profile/profile.dart';
import 'loader.dart';

class Draw extends StatefulWidget {
  const Draw({Key? key}) : super(key: key);

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getdata();
  }

  var name, following, followers, username, dp;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //This is for when you don't want to use sspecifed

  getdata() {
    final uid = _auth.currentUser!.uid;

    _firestore.collection("Users").doc(uid).get().then((e) {
      print(e.data()!["name"]);
      setState(() {
        name = e.data()!["name"];
        print("nam:" + name);
        dp = e.data()!["dp"];
        username = e.data()!["username"];
        followers = e.data()!["followers"];
        following = e.data()!["following"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return name == null
        ? const Progress()
        : Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: Colors.white),
                    accountName: Text(
                      name.toString(),
                      style: const TextStyle(color: Colors.black),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(dp),
                    ),
                    accountEmail: Text("@$username",
                        style: const TextStyle(color: Colors.black))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("${following.length} following"),
                    Text("${followers.length} followers")
                  ],
                ),
                const Divider(
                  thickness: 0.2,
                ),
                Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, Profile.id);
                      },
                      leading: const Icon(Icons.person),
                      title: const Text("Profile"),
                    ),
                    const ListTile(
                      leading: Text(""),
                      title: Text(""),
                    ),
                    const ListTile(
                      leading: Text(""),
                      title: Text(""),
                    ),
                    const ListTile(
                      leading: Text(""),
                      title: Text(""),
                    ),
                    const ListTile(
                      leading: Text(""),
                      title: Text(""),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Text(""),
                      title: const Text(""),
                    ),
                    const Divider(
                      thickness: 0.2,
                    ),
                    ListTile(
                      onTap: () {},
                      leading: const Text(""),
                      title: const Text(""),
                    ),
                    const Divider(
                      thickness: 0.2,
                    ),
                    ListTile(
                      onTap: () {
                        Auth().signOut();
                      },
                      leading: const Text("Sign Out"),
                    ),
                  ],
                )
              ],
            ));
  }
}
