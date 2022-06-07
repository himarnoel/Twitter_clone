// ignore_for_file: prefer_typing_uninitialized_variables, use_key_in_widget_constructors, unused_import, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:social_media/auth_ui/signin.dart';
import 'package:social_media/nav/dp.dart';

import 'auth.dart';

class Signup extends StatefulWidget {
  static String id = "Register";

  final toggleView;

  const Signup({Key? key, this.toggleView}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignupState createState() => _SignupState();
}

String email = "";
String password = "";
String confirmPass = "";
String error = "";

String dob = "";
bool loading = false;
FirebaseAuth user = FirebaseAuth.instance;
final _formkey = GlobalKey<FormState>();
DateTime selectedDate = DateTime.now();
TextEditingController dateinput = TextEditingController();
TextEditingController name = TextEditingController();

class _SignupState extends State<Signup> {
  final Auth _auth = Auth();

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
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.12,
          width: 900,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Create  your Account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.7,
                      width: 900,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Input(
                              controller: name,
                              obscure: false,
                              read: false,
                              text: "Name",
                              keyboard: TextInputType.name,
                              value: (val) {},
                              valid: (val) {
                                if (val.isEmpty) {
                                  return "Please Enter your name";
                                } else
                                  // ignore: curly_braces_in_flow_control_structures
                                  return null;
                              }),
                          Input(
                            read: false,
                            obscure: false,
                            text: "email",
                            value: (val) {
                              email = val;
                            },
                            keyboard: TextInputType.emailAddress,
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
                            controller: dateinput,
                            obscure: false,
                            read: true,
                            text: "Date of Birth",
                            valid: (val) {
                              if (val.isEmpty) {
                                return "Please Enter your name";
                              } else {
                                return null;
                              }
                            },
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(
                                      1000), //DateTime.now() - not; to allow to choose before today.
                                  lastDate: DateTime(2101));
                              if (picked != null) {
                                print(
                                    picked); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(picked);
                                //formatted date output using intl package =>  2021-03-16
                                //you can implement different kind of Date Format here according to your requirement

                                setState(() {
                                  dateinput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },

                            keyboard: TextInputType.number,
                            // ignore: prefer_const_constructors
                          ),
                          Input(
                            obscure: true,
                            read: false,
                            text: "Password",
                            keyboard: TextInputType.visiblePassword,
                            value: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            valid: (val) {
                              confirmPass = val;
                              if (val.isEmpty) {
                                return "Please Enter New Password";
                              } else if (val.length < 8) {
                                return "Password must be atleast 8 characters long";
                              } else {
                                return null;
                              }
                            },
                          ),
                          Input(
                            obscure: true,
                            read: false,
                            text: " Confirm Password",
                            keyboard: TextInputType.visiblePassword,
                            value: (val) {},
                            valid: (val) {
                              if (val.isEmpty) {
                                return "Please Re-Enter New Password";
                              } else if (val.length < 8) {
                                return "Password must be atleast 8 characters long";
                              } else if (val != confirmPass) {
                                return "Password do not match";
                              } else {
                                return null;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )),
              const Spacer(),
              Center(
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Dp(
                                email: email,
                                password: password,
                                dob: dateinput.text,
                                name: name.text);
                          }));
                        }
                      },
                      child: const Text("Next")),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account already ?"),
                  TextButton(
                      onPressed: () {
                        widget.toggleView();
                      },
                      child: const Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Input extends StatelessWidget {
  @required
  final obscure;
  final text, read;
  final value, controller;
  final icon, keyboard;
  final valid, onTap;

  const Input(
      {this.obscure,
      this.text,
      this.value,
      this.icon,
      this.valid,
      this.keyboard,
      this.onTap,
      this.controller,
      this.read});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      child: SizedBox(
        width: width / 1.2,
        child: TextFormField(
          readOnly: read,
          controller: controller,
          onTap: onTap,
          validator: valid,
          onChanged: value,
          obscureText: obscure,
          keyboardType: keyboard,
          decoration: InputDecoration(
            labelText: text,
            prefixIcon: icon,
          ),
        ),
      ),
    );
  }
}
