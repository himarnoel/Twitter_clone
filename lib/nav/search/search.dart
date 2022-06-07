// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../../twit/model_tweet.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final Tweets _tweets = Tweets();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: height / 1.24,
            width: width,
            child: StreamBuilder(
                stream:
                    _firestore.collection("Users").orderBy("name").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                          separatorBuilder: (_, i) => Divider(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_, i) {
                            DocumentSnapshot ds = snapshot.data!.docs[i];
                            var myuid = _auth.currentUser!.uid;
                            final List followers = ds["followers"];
                            return Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: NetworkImage(ds["dp"]),
                                ),
                                title: Text(ds["name"]),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(ds["username"]),
                                    SizedBox(height: 4),
                                    Text(ds["bio"])
                                  ],
                                ),
                                trailing: _auth.currentUser!.uid == ds["uid"]
                                    ? null
                                    : ElevatedButton(
                                        onPressed: () {
                                          _tweets.follow(myuid, ds.id);
                                        },
                                        child: followers.contains(myuid)
                                            ? Text("Unfollow")
                                            : Text("Follow")),
                              ),
                            );
                          });
                    }
                  }
                  return const AlertDialog(
                    title: Text(" Network Error"),
                  );
                }),
          )
        ],
      ),
    );
  }
}
