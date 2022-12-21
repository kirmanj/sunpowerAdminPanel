import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/add_brand.dart';
import 'package:explore/add_model.dart';
import 'package:explore/add_category.dart';
import 'package:explore/add_user.dart';
import 'package:explore/load_pdf.dart';
import 'package:explore/login.dart';
import 'package:explore/pdfread.dart';
import 'package:flutter/material.dart';

import 'add_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  getBrands() {
    List _isHovering = [];
    List _isSelected = [];
    List<String> brandImage = [];
    List<String> brands = [];

    FirebaseFirestore.instance.collection('brand').get().then((value) {
      value.docs.forEach((element) {
        _isHovering.add(false);
        _isSelected.add(false);
        brandImage.add(element.data()['img']);
        brands.add(element.data()['name']);
      });
      if (_isSelected.length != 0) {
        _isSelected[0] = true;
      }
    }).whenComplete(() {
      print(_isSelected);
      print(_isHovering);
      print(brandImage);
      print(brands);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddCategory()));
                  },
                  child: Container(
                      width: width * 0.1,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 143, 158, 1),
                              Color.fromRGBO(255, 188, 143, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Center(
                          child: Text('Add Category',
                              style: TextStyle(
                                color: Colors.white,
                              ))))),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddModel()));
                  },
                  child: Container(
                      width: width * 0.1,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 143, 158, 1),
                              Color.fromRGBO(255, 188, 143, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Center(
                          child: Text('Add Make & Model',
                              style: TextStyle(
                                color: Colors.white,
                              ))))),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddBrand()));
                  },
                  child: Container(
                      width: width * 0.1,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 143, 158, 1),
                              Color.fromRGBO(255, 188, 143, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Center(
                          child: Text('Add Brand',
                              style: TextStyle(
                                color: Colors.white,
                              ))))),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddProduct()));
                  },
                  child: Container(
                      width: width * 0.1,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 143, 158, 1),
                              Color.fromRGBO(255, 188, 143, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Center(
                          child: Text('Add Product',
                              style: TextStyle(
                                color: Colors.white,
                              ))))),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Container(
                      width: width * 0.1,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 143, 158, 1),
                              Color.fromRGBO(255, 188, 143, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.2),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            )
                          ]),
                      child: Center(
                          child: Text('Add User',
                              style: TextStyle(
                                color: Colors.white,
                              ))))),
            ],
          ),
        ),
      ),
    );
  }
}
