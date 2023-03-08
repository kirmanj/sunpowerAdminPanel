import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/authdialog.dart';
import 'package:explore/homeScreen.dart';
import 'package:explore/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password, _name, _phone, _address;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool wholeSale = true;

  @override
  void initState() {
    getUser();
    print(uid);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: uid != null ? HomeScreen() : AuthDialog(),
      ),
    );
  }

  final _success = SnackBar(
    content: Text(
      'Added Successfully',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
  );
}
