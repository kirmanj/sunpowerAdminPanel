import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/add_brand.dart';
import 'package:explore/add_brands.dart';
import 'package:explore/add_category.dart';
import 'package:explore/add_user.dart';
import 'package:explore/adminControl.dart';
import 'package:explore/authdialog.dart';
import 'package:explore/login.dart';
import 'package:explore/main.dart';
import 'package:explore/products.dart';
import 'package:explore/utils/authentication.dart';
import 'package:explore/web/newOrders.dart';
import 'package:explore/web/order_history.dart';
import 'package:explore/web/responsive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'add_model.dart';
import 'add_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future sendEmail(String name, String email, String message) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_d5pwnh5';
    const templateId = 'template_getrdfq';
    const userId = 'TN60o15EaFKV5yCp7';
    print("krmanj");
    print(templateId);
    print(serviceId);
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin":
              "Origin, X-Requested-With, Content-Type, Accept",
          'Accept': '*/*'
        }, //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'from_name': name,
            'from_email': email,
            'message': message
          }
        }));
    return response.statusCode;
  }

  @override
  void initState() {
    // sendEmail("New Order", "krmanj Fars tahir", "This message is from krmanj");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [],
        backgroundColor: Color.fromARGB(255, 78, 162, 154),
        title: Container(
          width: width,
          child: ListTile(
            minLeadingWidth: 0,
            leading: Container(
              height: height * 0.1,
              width: ResponsiveWidget.isSmallScreen(context)
                  ? width * 0.5
                  : width * 0.15,
              child: Image.asset(
                'assets/images/sunpower2.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            trailing: Text(
              "Admin Panel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
      body: uid != "99Dtd1qW7eSjFqA6864PKfBzFap2"
          ? AuthDialog()
          : Container(
              color: Colors.white,
              width: width,
              child: ResponsiveWidget.isSmallScreen(context)
                  ? Card(
                      elevation: 5,
                      color: Colors.white,
                      child: Center(
                          child: ListTile(
                        title: Text(
                            "Sunpower Admin is only available on Laptop Screen"),
                        subtitle: Icon(
                          Icons.laptop_mac_outlined,
                          color: Colors.black87,
                          size: 55,
                        ),
                      )),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                    onTap: () {
                                      List images = [];
                                      List slideImages = [];
                                      int deliveryFee = 0;
                                      int dinnar = 0;
                                      FirebaseFirestore.instance
                                          .collection('Admin')
                                          .doc("admindoc")
                                          .get()
                                          .then((value) {
                                        images = value.get("offerImages");
                                        deliveryFee = value.get("deliveryfee");
                                        slideImages = value.get("sliderImages");
                                        dinnar = value.get("dinnar");
                                      }).then((value) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminControl(
                                                        images,
                                                        slideImages,
                                                        deliveryFee,
                                                        dinnar)));
                                      });
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]),
                                        child: Center(
                                            child: Text('Admin Control',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))))),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddCategory()));
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
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
                                      List<dynamic> categories = [];

                                      FirebaseFirestore.instance
                                          .collection("make")
                                          .get()
                                          .then((value) {
                                        int i = 0;
                                        // setState(() {
                                        //   categories = value.docs;
                                        // });
                                        value.docs.forEach((element) async {
                                          Reference storage = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child(element['img']);
                                          String url =
                                              await storage.getDownloadURL();
                                          setState(() {
                                            categories.add({
                                              'make': element['make'],
                                              'img': url,
                                              'id': element.id,
                                              'makeA': element['makeA'],
                                              'makeK': element['makeK']
                                            });

                                            // categories[i] = {
                                            //   'make': element['make'],
                                            //   'img': url,
                                            //   'id': element.id
                                            // };
                                          });

                                          if (i == (value.docs.length - 1)) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddModel(categories)));
                                          }
                                          i++;
                                        });

                                        print(categories);
                                      }).whenComplete(() {});
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]),
                                        child: Center(
                                            child: Text('Add Model',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))))),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddProduct()));
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()));
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
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
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BrandsNew()));
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Products()));
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]),
                                        child: Center(
                                            child: Text('Products',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))))),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderHistory()));
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]),
                                        child: Center(
                                            child: Text('Order History',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))))),
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddBrand()));
                                    },
                                    child: Container(
                                        width: width * 0.08,
                                        height: height * 0.08,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(
                                                    255, 0, 178, 169),
                                                Color.fromARGB(
                                                    255, 0, 106, 101),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3),
                                              )
                                            ]),
                                        child: Center(
                                            child: Text('Brands',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))))),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Container(
                            width: width * 0.5,
                            height: height * 0.9,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Center(
                                      child: Text(
                                    "New Orders",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  )),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: height * 0.8,
                                    // color: Colors.red,
                                    child: NewOrders())
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            ),
    );
  }
}
