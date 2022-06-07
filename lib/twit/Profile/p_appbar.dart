import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Bar extends StatefulWidget {
  const Bar({Key? key}) : super(key: key);

  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection("Users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          var dat = snapshot.data!;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (contex, i) {
                    DocumentSnapshot ds = snapshot.data!.docs[i];
                    return AppBar(
                      elevation: 0,
                      backgroundColor: Colors.blueGrey.shade50,
                      title: ListTile(
                        title: Text(ds["name"]),
                        subtitle: Text("${ds["tweets"].length}Tweets"),
                      ),
                      iconTheme: const IconThemeData(color: Colors.black),
                    );
                  });
            }
          }
          return const AlertDialog(
            title: Text(" Network Error"),
          );
        });
  }
}
