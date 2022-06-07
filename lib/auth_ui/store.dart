import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class Store {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  db({
    required String uid,
    required String name,
    required String email,
    required String username,
    required String dob,
    required String bio,
    required File image,
  }) async {
    String dp;
    final path = "${_auth.currentUser!.uid}/dp${_auth.currentUser!.uid}";
    final file = File(image.path);
    Reference ref = _storage.ref().child(path);

    UploadTask upload = ref.putFile(file);
    TaskSnapshot snapShot = await upload;
    dp = await snapShot.ref.getDownloadURL();
    _firestore.collection("Users").doc(uid).set({
      "uid": uid,
      "name": name,
      "email": email,
      "username": username,
      "dob": dob,
      "bio": bio,
      "dp": dp,
      "joined": DateFormat("MMMM yyyy").format(DateTime.now()),
      "following": [],
      "followers": [],
      "tweets": []
    });
  }
}
