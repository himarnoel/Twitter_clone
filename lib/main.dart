import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_media/auth_ui/signup.dart';
import 'package:social_media/auth_ui/switch.dart';
import 'package:social_media/component/loader.dart';

import 'auth_ui/signin.dart';
import 'gate.dart';
import 'nav/home.dart';
import 'nav/nav.dart';
import 'twit/Profile/profile.dart';
import 'twit/tweet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.white,
        bottomAppBarColor: Colors.white,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: Gate.id,
      routes: {
        Nav.id: (context) => const Nav(),
        Home.id: (context) => const Home(),
        Tweet.id: (context) => const Tweet(),
        Profile.id: (context) => const Profile(),
        Gate.id: (context) => const Gate(),
        Signup.id: (context) => const Signup(),
        Login.id: (context) => const Login(),
        Switchin.id: (context) => const Switchin(),
        Switch2.id: (context) => const Switch2(),
        Progress.id: (context) => const Progress()
      },
    );
  }
}
