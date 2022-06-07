import 'package:flutter/material.dart';
import 'package:social_media/auth_ui/signin.dart';
import 'package:social_media/auth_ui/signup.dart';

class Switchin extends StatefulWidget {
  static String id = "Switch";
  const Switchin({Key? key}) : super(key: key);

  @override
  _SwitchinState createState() => _SwitchinState();
}

class _SwitchinState extends State<Switchin> {
  bool isLogin = true;
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Signup(toggleView: toggle);
    } else {
      return Login(toggleView: toggle);
    }
  }
}

class Switch2 extends StatefulWidget {
  static String id = "switch2";
  const Switch2({Key? key}) : super(key: key);

  @override
  _Switch2State createState() => _Switch2State();
}

class _Switch2State extends State<Switch2> {
  @override
  bool isLogin = true;
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return Login(toggleView: toggle);
    } else {
      return Signup(toggleView: toggle);
    }
  }
}
