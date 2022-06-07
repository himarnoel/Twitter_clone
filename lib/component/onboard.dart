// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:social_media/auth_ui/signin.dart';
import 'package:social_media/auth_ui/signup.dart';
import 'package:social_media/auth_ui/switch.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Icon(
          FontAwesome.twitter,
          color: Colors.blue,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Center(
            child: Text(
              "\nSee What's\n happening in the\n world right now.",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: height / 20,
          ),
          SizedBox(
            width: width / 1.3,
            height: height / 15,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                onPressed: () {
                  Navigator.pushNamed(context, Switchin.id);
                },
                child: const Text("create account")),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Have an account already ?"),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Switch2.id);
                  },
                  child: const Text("Login"))
            ],
          )
        ],
      ),
    );
  }
}
