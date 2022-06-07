// ignore_for_file: unused_local_variable, prefer_typing_uninitialized_variables, prefer_const_constructors_in_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:social_media/auth_ui/signup.dart';

import 'auth.dart';

class Login extends StatefulWidget {
  static String id = "Login";
  final toggleView;

  const Login({Key? key, this.toggleView}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  final Auth _auth = Auth();
  String email = "";
  String password = "";
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const Icon(
            FontAwesome.twitter,
            color: Colors.blue,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                widget.toggleView();
              },
              child: const Text("Signup", style: TextStyle(color: Colors.blue)),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.white,
              ),
            ),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Login in to Twitter",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 200,
                        width: 900,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Input(
                              obscure: false,
                              text: "Email",
                              keyboard: TextInputType.emailAddress,
                              value: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              valid: (val) {
                                if (val.isEmpty) {
                                  return "Please an Email";
                                } else {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val);
                                  if (emailValid == true) {
                                    return null;
                                  } else {
                                    return "Enter a correct email";
                                  }
                                }
                              },
                            ),
                            Input(
                              obscure: true,
                              text: "Password",
                              keyboard: TextInputType.visiblePassword,
                              value: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              valid: (val) {
                                if (val.isEmpty) {
                                  return "Please Enter your Password";
                                } else if (val.length < 8) {
                                  return "Password must be atleast 8 characters long";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
                Center(
                  child: SizedBox(
                    height: height / 20,
                    width: width / 2,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            if (loading) {
                              showDialog(
                                  barrierDismissible: false,
                                  barrierColor: Colors.white,
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  });
                            }
                            dynamic result =
                                await _auth.login(email, password, context);

                            loading = false;

                            if (loading == false) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously

                            }
                            if (user.currentUser!.uid.isNotEmpty) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text("Login")),
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Input extends StatelessWidget {
  @required
  final bool obscure;
  final String text;
  final value;
  final icon, keyboard;
  final valid;

  Input(
      {Key? key,
      required this.obscure,
      required this.text,
      required this.value,
      this.icon,
      required this.valid,
      this.keyboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: valid,
      onChanged: value,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: icon,
      ),
    );
  }
}
