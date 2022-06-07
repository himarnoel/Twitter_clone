import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/component/onboard.dart';

import 'nav/dp.dart';
import 'nav/nav.dart';

class Gate extends StatelessWidget {
  static String id = "Gate";
  const Gate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.grey.shade100),
          );
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const Nav();
          }
        }

        return const Onboard();
      },
    );
  }
}
