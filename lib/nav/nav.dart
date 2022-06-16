import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import 'package:social_media/nav/search/model_search.dart';

import '../component/drawer.dart';
import '../twit/tweet.dart';
import 'home.dart';
import 'message.dart';
import 'notification.dart';
import 'search/search.dart';

class Nav extends StatefulWidget {
  static String id = "NavBar";

  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var image;
  int _ontap = 0;
  List pages = const [
    Home(),
    Search(),
  ];
  get() async {
    try {
      await _firestore
          .collection("Users")
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        setState(() {
          image = value.data()!["dp"];
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Draw(),
      appBar: _ontap == 1
          ? AppBar(
              leading: Builder(
                builder: (context) {
                  return InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            image == null ? null : NetworkImage(image),
                      ),
                    ),
                  );
                },
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Container(
                height: 26,
                width: 250,
                child: TextFormField(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showSearch(context: context, delegate: Searchprofile());
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.blue,
                      labelText: "search Twitter",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
              ),
              actions: [],
            )
          : AppBar(
              leading: Builder(
                builder: (context) {
                  return InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            image == null ? null : NetworkImage(image),
                      ),
                    ),
                  );
                },
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              centerTitle: true,
              title: const Icon(
                FontAwesome.twitter,
                color: Colors.blue,
              ),
              actions: const [
                Icon(Typicons.star, size: 15, color: Colors.black)
              ],
              iconTheme: const IconThemeData(color: Colors.black),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          Navigator.pushNamed(context, Tweet.id);
        },
      ),
      body: pages[_ontap],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (val) {
          setState(() {
            _ontap = val;
          });
        },
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _ontap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: ""),

         
        ],
      ),
    );
  }
}
