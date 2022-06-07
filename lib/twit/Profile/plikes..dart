import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:fluttericon/font_awesome_icons.dart';

import '../model_tweet.dart';

class Likes extends StatefulWidget {
  const Likes({Key? key}) : super(key: key);

  @override
  _LikesState createState() => _LikesState();
}

class _LikesState extends State<Likes> {
  List check = [];
  @override
  void initState() {
    // TODO: implement initState
    // getdata();
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Tweets tweets = Tweets();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: height / 1.24,
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder(
                  stream: _firestore
                      .collection("Tweets")
                      .orderBy("datePublished", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.active) {
                      var dat = snapshot.data!;
                      if (snapshot.hasData) {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data!.docs[index];
                              List color = ds["likes"];
                              return !color.contains(_auth.currentUser!.uid)
                                  ? SizedBox.shrink()
                                  : Container(
                                      height: ds["image"] != ''
                                          ? height / 2.2
                                          : height / 4.5,
                                      width: width,
                                      margin: const EdgeInsets.only(bottom: 8),
                                      // decoration:
                                      //     BoxDecoration(color: Colors.amber.shade100),
                                      child: Column(
                                        children: [
                                          ListTile(
                                              title: Row(
                                                children: [
                                                  Text(ds["name"]),
                                                  SizedBox(
                                                    width: width / 17,
                                                  ),
                                                  Text(
                                                    "@${ds["username"]}",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10),
                                                  ),
                                                  SizedBox(
                                                    width: width / 50,
                                                  ),
                                                  Text(
                                                    "${ds["datePublished"]}",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10),
                                                  )
                                                ],
                                              ),
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.grey,
                                                backgroundImage:
                                                    NetworkImage(ds["dp"]),
                                              ),
                                              trailing:
                                                  _auth.currentUser!.uid !=
                                                          ds["uid"]
                                                      ? null
                                                      : IconButton(
                                                          icon: const Icon(
                                                              Icons.more_horiz),
                                                          onPressed: () {
                                                            delete(ds: ds);
                                                          },
                                                        )),
                                          Text(ds["tweet"]),
                                          SizedBox(
                                            height: height / 30,
                                          ),
                                          ds["image"] != ''
                                              ? Image(
                                                  // width: width / 1.4,
                                                  image: NetworkImage(
                                                    ds["image"],
                                                    scale: 10,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.reply,
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: width / 50,
                                                      ),
                                                      Text(
                                                          width != 0 ? "" : "3")
                                                    ],
                                                  )),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: Row(
                                                    children: [
                                                      const Icon(
                                                          FontAwesome.retweet,
                                                          size: 15),
                                                      SizedBox(
                                                        width: width / 50,
                                                      ),
                                                      Text(
                                                          width != 0 ? "" : "3")
                                                    ],
                                                  )),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        tweets.likePost(
                                                            ds.id,
                                                            _auth.currentUser!
                                                                .uid,
                                                            ds["likes"]);
                                                      },
                                                      icon: Icon(Icons.favorite,
                                                          color: color.contains(
                                                                  _auth
                                                                      .currentUser!
                                                                      .uid)
                                                              ? Colors.red
                                                              : Colors.grey,
                                                          size: 15)),
                                                  Text(
                                                    ds["likes"]
                                                        .length
                                                        .toString(),
                                                  ),
                                                  SizedBox(
                                                    width: width / 50,
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.share,
                                                          size: 15)),
                                                  SizedBox(
                                                    width: width / 50,
                                                  ),
                                                  Text(width != 0 ? "" : "3")
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 0.7,
                                          ),
                                        ],
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
      ),
    );
  }

  delete({var ds}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red.shade300,
                  ),
                  title: const Text("Delete this post"),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Alert"),
                            content: Text(
                              "Are you sure you want to delete this post?",
                              style: TextStyle(color: Colors.red.shade400),
                            ),
                            actions: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _firestore
                                        .collection("Tweets")
                                        .doc(ds.id)
                                        .delete();
                                  },
                                  child: const Text("Ok")),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Cancel"))
                            ],
                          );
                        });
                  }),
            ],
          );
        });
  }
}
