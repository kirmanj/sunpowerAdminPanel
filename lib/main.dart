import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:explore/adminControl.dart';
import 'package:explore/authdialog.dart';
import 'package:explore/homeScreen.dart';
import 'package:explore/login.dart';
import 'package:explore/products.dart';
import 'package:explore/scrollbehaivori.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/utils/theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    EasyDynamicThemeWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sunpower Admin',
      theme: lightThemeData,
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
