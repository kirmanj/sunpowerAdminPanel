import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/edit_products.dart';
import 'package:explore/homeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> images = [];

  List categoryList = [];
  String categoryID = '';
  String image = '';
  List tempProductList = [];
  List productList = [];
  String selectedCategory = '';

  getCategory() {
    FirebaseFirestore.instance.collection('categories').get().then((value) {
      // setState(() {
      //   selectedCategory = value.docs[0].id;
      // });
      int i = 0;
      value.docs.forEach((element) async {
        Reference storage =
            FirebaseStorage.instance.ref().child(element['img']);
        String url = await storage.getDownloadURL();

        setState(() {
          categoryList
              .add({'name': element['name'], 'img': url, 'id': element.id});
        });
        // setState(() {
        //   categoryList.add(element);
        // });
        i++;
      });
      // if (i == value.docs.length - 1) {
      //   setState(() {
      //     selectedCategory = categoryList[0]['id'];
      //   });
      // }
    });

    FirebaseFirestore.instance.collection('products').get().then((value) {
      value.docs.forEach((element) async {
        Reference storage =
            FirebaseStorage.instance.ref().child(element['images'][0]);
        String url = await storage.getDownloadURL();

        setState(() {
          tempProductList.add({
            'name': element['name'],
            'categoryId': element['categoryID'],
            'img': url,
            'id': element.id
          });
        });
      });
    });
  }

  updateList() {
    productList = [];
    tempProductList.forEach((element) {
      if (element['categoryId'] == selectedCategory) {
        setState(() {
          productList.add(element);
        });
      }
    });
  }

  final menuProducts = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(body: Builder(
      builder: (BuildContext context) {
        return Container(
            height: height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomeScreen()));
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Color.fromARGB(255, 13, 143, 136),
                                )),
                            SizedBox(
                              width: width * 0.4,
                            ),
                            Container(
                                width: width * 0.1,
                                height: height * 0.05,
                                decoration: BoxDecoration(
                                    border: const GradientBoxBorder(
                                      gradient: LinearGradient(colors: [
                                        Color.fromARGB(255, 0, 178, 169),
                                        Color.fromARGB(255, 0, 106, 101),
                                      ]),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(child: Text('Products Panel'))),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                              width: width * 0.23,
                              height: height * 0.8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: categoryList.isEmpty
                                  ? Container()
                                  : Container(
                                      height: height * 0.6,
                                      child: GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: categoryList.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15,
                                                  left: 15.0,
                                                  right: 15),
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectedCategory =
                                                        categoryList[index]
                                                            ['id'];
                                                  });
                                                  updateList();
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  shadowColor:
                                                      selectedCategory ==
                                                              categoryList[
                                                                  index]['id']
                                                          ? Colors.red
                                                          : Colors.black,
                                                  color: Colors.white,
                                                  child: Container(
                                                    height: height * 0.1,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width: width * 0.05,
                                                          height: height * 0.08,
                                                          child: Image.network(
                                                            categoryList[index]
                                                                ['img'],
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Text(
                                                          categoryList[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ));
                                        },
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              width > width * 0.3 ? 2 : 1,
                                          childAspectRatio: 1.5,
                                        ),
                                      ))),
                          Padding(
                            padding: EdgeInsets.all(width * 0.0146),
                            child: Container(
                                width: width * 0.7,
                                height: height * 0.8,
                                padding: EdgeInsets.all(width * 0.0146),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Container(
                                  child:
                                      productList.isEmpty &&
                                              tempProductList.isNotEmpty
                                          ? Container(
                                              height: height * 0.5,
                                              child: GridView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount:
                                                    tempProductList.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 15,
                                                          left: 15.0,
                                                          right: 15),
                                                      child: Card(
                                                        elevation: 5,
                                                        color: Colors.white,
                                                        shadowColor: Colors
                                                            .green
                                                            .withOpacity(0.5),
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 15),
                                                          child: Center(
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.2,
                                                                  child: Center(
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              width * 0.1,
                                                                          height:
                                                                              height * 0.1,
                                                                          child:
                                                                              Image.network(
                                                                            tempProductList[index]['img'].toString(),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          tempProductList[index]['name']
                                                                              .toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child:
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            FirebaseFirestore.instance.collection('products').doc(tempProductList[index]['id']).get().then((value) {
                                                                              print(value["itemCode"]);
                                                                              Map product = {
                                                                                "itemCode": value["itemCode"],
                                                                                "categoryID": value["categoryID"],
                                                                                "volt": value["volt"],
                                                                                "oemCode": value["oemCode"],
                                                                                "images": value["images"],
                                                                                "nameA": value["nameA"],
                                                                                "makeId": value["makeId"],
                                                                                "productID": value["productID"],
                                                                                "piecesInBox": value["piecesInBox"],
                                                                                "brand": value["brand"],
                                                                                "descA": value["descA"],
                                                                                "old price": value["old price"],
                                                                                "cost price": value["cost price"],
                                                                                "retail price": value["retail price"],
                                                                                "desc": value["desc"],
                                                                                "name": value["name"],
                                                                                "wholesale price": value["wholesale price"],
                                                                                "descK": value["descK"],
                                                                                "nameK": value["nameK"],
                                                                                "barCode": value["barCode"],
                                                                                "quantity": value["quantity"],
                                                                                "pdfUrl": value["pdfUrl"],
                                                                                "modelId": value["modelId"]
                                                                              };
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(product)));
                                                                            });
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.edit,
                                                                            color:
                                                                                Colors.black87,
                                                                            size:
                                                                                16,
                                                                          )),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ));
                                                },
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      width > width * 0.3
                                                          ? 4
                                                          : 1,
                                                  childAspectRatio: 1.5,
                                                ),
                                              ))
                                          : productList.isEmpty
                                              ? Container(
                                                  child: Center(
                                                      child: Text("No Data")),
                                                )
                                              : Container(
                                                  height: height * 0.5,
                                                  child: GridView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        productList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (productList[index]
                                                              ["categoryId"] ==
                                                          selectedCategory) {
                                                        return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 15,
                                                                    left: 15.0,
                                                                    right: 15),
                                                            child: Card(
                                                              elevation: 5,
                                                              color:
                                                                  Colors.white,
                                                              shadowColor: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                      0.5),
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            15),
                                                                child: Center(
                                                                  child: Stack(
                                                                    children: [
                                                                      Container(
                                                                        height: height *
                                                                            0.2,
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Container(
                                                                                width: width * 0.1,
                                                                                height: height * 0.1,
                                                                                child: Image.network(
                                                                                  productList[index]['img'].toString(),
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                productList[index]['name'].toString(),
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: 12, color: Colors.black),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 0,
                                                                        right:
                                                                            0,
                                                                        child: IconButton(
                                                                            onPressed: () {},
                                                                            icon: Icon(
                                                                              Icons.edit,
                                                                              color: Colors.black87,
                                                                              size: 16,
                                                                            )),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ));
                                                      } else {
                                                        return Container();
                                                      }
                                                    },
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          width > width * 0.3
                                                              ? 4
                                                              : 1,
                                                      childAspectRatio: 1.5,
                                                    ),
                                                  )),
                                )),
                          ),
                        ],
                      ),
                    ],
                  )),
            ));
      },
    ));
  }
}
