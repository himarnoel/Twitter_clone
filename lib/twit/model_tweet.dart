// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/component/loader.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Tweets {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var postId = Uuid().v1();
  final ago = DateTime.now().subtract(const Duration(minutes: 1));
  final id = UniqueKey().hashCode;
  var val;
  tweet(
      {required BuildContext context,
      required String post,
      required String username,
      required String name,
      required String dp,
      required var image}) async {
    bool load = false;
    String? postUrl;
    if (image != null) {
      final path = "${_auth.currentUser!.uid}/dp$postId";
      final file = File(image.path);
      Reference ref = _storage.ref().child(path);
      UploadTask upload = ref.putFile(file);
      TaskSnapshot snapShot = await upload;
      postUrl = await snapShot.ref.getDownloadURL();
    }
    try {
      _firestore.collection("Tweets").add({
        "tweet": post,
        "uid": _auth.currentUser!.uid,
        "username": username,
        "name": name,
        "datePublished": DateTime.now().minute.toString(),
        "image": postUrl ?? '',
        "dp": dp,
        "likes": [],
      }).whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);
      });
      // var id = _firestore.collection("collectionPath").id;
      // _firestore.collection("Users").doc(_auth.currentUser!.uid).update({
      //   "tweets": FieldValue.arrayUnion([id])
      // });
    } catch (e) {
      print(e.toString());
    }
  }

  likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('Tweets').doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('Tweets').doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> follow(String myuid, String followId) async {
    try {
      DocumentSnapshot<dynamic> snap =
          await _firestore.collection('Users').doc(myuid).get();

      List following = snap.data()!['following'];

      if (following.contains(followId)) {
        await _firestore.collection('Users').doc(followId).update({
          "followers": FieldValue.arrayRemove([myuid])
        });
        await _firestore.collection('Users').doc(myuid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('Users').doc(myuid).update({
          "following": FieldValue.arrayUnion([followId])
        });
        await _firestore.collection('Users').doc(followId).update({
          "followers": FieldValue.arrayUnion([myuid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  followers(String uid) async {
    try {
      DocumentSnapshot<dynamic> snap =
          await _firestore.collection('Users').doc(uid).get();
      List following = snap.data()!['following'];
      List followers = snap.data()!['followers'];

      if (following.contains(uid)) {
        await _firestore.collection('Users').doc(uid).update({
          "followers": FieldValue.arrayRemove([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
