import 'package:explore/add_brand.dart';
import 'package:explore/add_category.dart';
import 'package:explore/add_user.dart';
import 'package:explore/login.dart';
import 'package:explore/web/newOrders.dart';
import 'package:explore/web/order_history.dart';
import 'package:flutter/material.dart';

import 'add_model.dart';
import 'add_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(

        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Row(
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
                            child: Text('Add Model',
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
                InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OrderHistory()));
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
                            child: Text('Order History',
                                style: TextStyle(
                                  color: Colors.white,
                                ))))),
              ],
            ),
            SizedBox(height: 50,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:   Center(child: Text("NEW Orders",style: TextStyle(fontWeight:FontWeight.w500,fontSize: 25),)),
            ),
            SizedBox(height: 20,),
            Container(
                height: height - 300,
                // color: Colors.red,
                child: NewOrders())
          ],
        ),
      ),
    );
  }
}
