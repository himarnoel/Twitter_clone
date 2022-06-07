import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media/nav/nav.dart';
import 'package:social_media/twit/model_tweet.dart';

class Searchprofile extends SearchDelegate {
  final Tweets _tweets = Tweets();
  FirebaseFirestore _reference = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return StreamBuilder<QuerySnapshot>(
      stream: _reference.collection("Users").snapshots(),
      builder: (Context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (!snapshot.hasData) {
            const Center(
              child: Text("data"),
            );
          }
          if (snapshot.hasData) {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>
                        element["name"]
                            .toString()
                            .toLowerCase()
                            .toLowerCase()
                            .contains(query.toLowerCase()))
                    .map((QueryDocumentSnapshot<Object?> e) {
                  var myuid = _auth.currentUser!.uid;
                  final String name = e.get("name");
                  final String image = e["dp"];
                  final String username = e["username"];
                  final String bio = e["bio"];
                  final String uid = e["uid"];
                  final List followers = e["followers"];
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            print(uid);
                          },
                          title: Text(name),
                          leading: CircleAvatar(
                            radius: 43,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(image),
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username),
                              SizedBox(height: 2),
                              Text(bio)
                            ],
                          ),
                          trailing: _auth.currentUser!.uid == uid
                              ? null
                              : ElevatedButton(
                                  onPressed: () {
                                    _tweets.follow(myuid, uid);
                                    print(uid);
                                    print(myuid);
                                    print(followers.contains(myuid));
                                  },
                                  child: followers.contains(myuid)
                                      ? Text("Unfollow")
                                      : Text("Follow")),
                        ),
                        Divider()
                      ],
                    ),
                  );
                })
              ],
            );
          }
        }
        return const Text("No Search Query");
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text("Search for other Users"),
    );
  }
}
