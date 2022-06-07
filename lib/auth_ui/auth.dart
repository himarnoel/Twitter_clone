// ignore_for_file: unused_import, unused_field, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:social_media/auth_ui/store.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final Store _store = Store();
  String code = "Network Error";

  signUp(
      {required String email,
      required String username,
      required String password,
      required String dob,
      required String bio,
      required String name,
      required File image,
      required BuildContext context}) async {
    print("name ${name}");
    try {
      // ignore: unused_local_variable
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      _store.db(
          uid: user.user!.uid,
          name: name,
          email: email,
          username: username,
          dob: dob,
          bio: bio,
          image: image);
    } on FirebaseException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          code = "Email is already in use ";
          break;
        case "user-disabled":
          code = "This account is disabled";
          break;
        case "user-not-found":
          code = "The account is found";
          break;
        case "wrong-password":
          code = "Your password is wrong";
          break;
        default:
          null;
      }
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Login failed",
                style: TextStyle(color: Colors.red),
              ),
              content: Text(code),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ok"))
              ],
            );
          });
    }
  }

  login(String email, String password, BuildContext context) async {
    try {
      // ignore: unused_local_variable
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          code = "Invalid email";
          break;
        case "user-disabled":
          code = "This account is disabled";
          break;
        case "user-not-found":
          code = "The account is not found";
          break;
        case "wrong-password":
          code = "Your password is wrong";
          break;
        default:
          null;
      }
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Login failed",
                style: TextStyle(color: Colors.blue),
              ),
              content: Text(code,
                  style: TextStyle(
                    color: Colors.redAccent,
                  )),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ok"))
              ],
            );
          });
    }
    // ignore: unused_element
  }

  signOut() async {
    await _auth.signOut();
  }
}
