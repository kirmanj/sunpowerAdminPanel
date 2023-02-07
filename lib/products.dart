import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/edit_products.dart';
import 'package:explore/homeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  List<String> images = [];

  List makeList = [];
  List categoryList = [];

  String image = '';
  List tempProductList = [];
  List productList = [];
  String selectedCategory = '';
  String selectedMake = '';

  getCategory() {
    FirebaseFirestore.instance.collection('make').get().then((value) {
      value.docs.forEach((element) async {
        Reference storage =
            FirebaseStorage.instance.ref().child(element['img']);
        String url = await storage.getDownloadURL();

        setState(() {
          makeList.add({'name': element['make'], 'img': url, 'id': element.id});
        });
      });
    });

    FirebaseFirestore.instance.collection('categories').get().then((value) {
      value.docs.forEach((element) async {
        Reference storage =
            FirebaseStorage.instance.ref().child(element['img']);
        String url = await storage.getDownloadURL();

        setState(() {
          categoryList
              .add({'name': element['name'], 'img': url, 'id': element.id});
        });
      });
    });

    FirebaseFirestore.instance.collection('products').get().then((value) {
      int i = 0;
      value.docs.forEach((element) async {
        Reference storage =
            FirebaseStorage.instance.ref().child(element['images'][0]);
        String url = await storage.getDownloadURL();

        setState(() {
          tempProductList.add({
            'name': element['name'],
            'makeId': element['makeId'],
            'img': url,
            'itemCode': element['itemCode'],
            'id': element.id,
            'newArrival': element['newArrival'],
            "categoryID": element['categoryID']
          });
        });
      });
    });
  }

  bool category = false;
  bool make = false;

  updateList() {
    productList = [];
    tempProductList.forEach((element) {
      if (element['categoryID'] == selectedCategory && category && !make) {
        setState(() {
          productList.add(element);
        });
      } else if (element['makeId'] == selectedMake && make && !category) {
        setState(() {
          productList.add(element);
        });
      } else if (element['categoryID'] == selectedCategory &&
          element['makeId'] == selectedMake) {
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: width * 0.23,
                                    height: height * 0.38,
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: categoryList.isEmpty
                                        ? Container()
                                        : Container(
                                            child: Column(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: Text("Category "),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 9,
                                                child: GridView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      categoryList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                left: 5.0,
                                                                right: 5),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (selectedCategory ==
                                                                categoryList[
                                                                        index]
                                                                    ['id']) {
                                                              setState(() {
                                                                category =
                                                                    false;
                                                                selectedCategory =
                                                                    "";
                                                              });
                                                            } else {
                                                              setState(() {
                                                                category = true;
                                                              });
                                                              selectedCategory =
                                                                  categoryList[
                                                                          index]
                                                                      ['id'];
                                                            }

                                                            updateList();
                                                          },
                                                          child: Card(
                                                            elevation: 5,
                                                            shadowColor: selectedCategory ==
                                                                    categoryList[
                                                                            index]
                                                                        ['id']
                                                                ? Colors.red
                                                                : Colors.black,
                                                            color: Colors.white,
                                                            child: Container(
                                                              color: selectedCategory ==
                                                                      categoryList[
                                                                              index]
                                                                          ['id']
                                                                  ? Colors
                                                                      .red[900]
                                                                  : Colors
                                                                      .white,
                                                              height:
                                                                  height * 0.1,
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      child: Image
                                                                          .network(
                                                                        categoryList[index]
                                                                            [
                                                                            'img'],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      categoryList[
                                                                              index]
                                                                          [
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          color: selectedCategory == categoryList[index]['id']
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                          fontSize: 12),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      "",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
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
                                                        width > width * 0.3
                                                            ? 3
                                                            : 1,
                                                    childAspectRatio: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),
                                Container(
                                    width: width * 0.23,
                                    height: height * 0.38,
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
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: makeList.isEmpty
                                        ? Container()
                                        : Container(
                                            child: Column(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  child: Text("Make"),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 9,
                                                child: GridView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount: makeList.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                left: 5.0,
                                                                right: 5),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (selectedMake ==
                                                                makeList[index]
                                                                    ['id']) {
                                                              setState(() {
                                                                make = false;
                                                                selectedMake =
                                                                    "";
                                                              });
                                                            } else {
                                                              setState(() {
                                                                make = true;
                                                                selectedMake =
                                                                    makeList[
                                                                            index]
                                                                        ['id'];
                                                              });
                                                            }

                                                            updateList();
                                                          },
                                                          child: Card(
                                                            elevation: 5,
                                                            shadowColor:
                                                                selectedMake ==
                                                                        makeList[index]
                                                                            [
                                                                            'id']
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black,
                                                            color: Colors.white,
                                                            child: Container(
                                                              color: selectedMake ==
                                                                      makeList[
                                                                              index]
                                                                          ['id']
                                                                  ? Colors
                                                                      .red[900]
                                                                  : Colors
                                                                      .white,
                                                              height:
                                                                  height * 0.1,
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Container(
                                                                      child: Image
                                                                          .network(
                                                                        makeList[index]
                                                                            [
                                                                            'img'],
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      makeList[
                                                                              index]
                                                                          [
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          color: selectedMake == makeList[index]['id']
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                          fontSize: 12),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Text(
                                                                      "",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
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
                                                        width > width * 0.3
                                                            ? 3
                                                            : 1,
                                                    childAspectRatio: 2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))),
                              ],
                            ),
                          ),
                          Padding(
                            //   padding: EdgeInsets.all(width * 0),
                            padding: EdgeInsets.all(width * 0.0146),
                            child: Container(
                                width: width * 0.7,
                                height: height * 0.8,
                                //         padding: EdgeInsets.all(width * 0.0146),
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
                                              tempProductList.isNotEmpty &&
                                              !category &&
                                              !make
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
                                                          // margin:
                                                          //     EdgeInsets.only(
                                                          //         bottom: 15),
                                                          child: Center(
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.3,
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
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 20,
                                                                                child: IconButton(
                                                                                    onPressed: () {
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
                                                                                          "pdfUrl": value["pdfUrl"].toString(),
                                                                                          "modelId": value["modelId"]
                                                                                        };
                                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(product)));
                                                                                      });
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.edit,
                                                                                      color: Colors.black87,
                                                                                      size: 12,
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 2,
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    tempProductList[index]['name'].toString(),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                                                                  ),
                                                                                  Text(
                                                                                    tempProductList[index]['itemCode'].toString(),
                                                                                    textAlign: TextAlign.center,
                                                                                    style: TextStyle(fontSize: 12, color: Colors.black),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              flex: 1,
                                                                              child: Container(
                                                                                width: 20,
                                                                                height: 20,
                                                                                child: IconButton(
                                                                                    onPressed: () {
                                                                                      showDialog(
                                                                                        context: context,
                                                                                        builder: (_) => AlertDialog(
                                                                                          title: Text(
                                                                                            ' this product will be deleted, Are You Sure?',
                                                                                            style: TextStyle(fontSize: 14),
                                                                                          ),
                                                                                          // shape: CircleBorder(),
                                                                                          shape: BeveledRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(5.0),
                                                                                          ),
                                                                                          elevation: 30,
                                                                                          backgroundColor: Colors.white,
                                                                                          contentPadding: EdgeInsets.all(5),
                                                                                          actions: <Widget>[
                                                                                            InkWell(
                                                                                                onTap: () {
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                                child: Text(
                                                                                                  'No',
                                                                                                  style: TextStyle(fontSize: 20, color: Colors.red[900]),
                                                                                                )),
                                                                                            SizedBox(
                                                                                              height: 30,
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                FirebaseFirestore.instance.collection("products").doc(tempProductList[index]['id']).delete();
                                                                                                ScaffoldMessenger.of(context).showSnackBar(_delete);
                                                                                                Navigator.pop(context);
                                                                                                Navigator.pop(context);
                                                                                              },
                                                                                              child: Text('Yes', style: TextStyle(fontSize: 20, color: Colors.green[900])),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.delete,
                                                                                      color: Colors.black87,
                                                                                      size: 12,
                                                                                    )),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 0,
                                                                  right: 0,
                                                                  child:
                                                                      Container(
                                                                    child: Transform
                                                                        .scale(
                                                                      scale:
                                                                          0.5,
                                                                      child: CupertinoSwitch(
                                                                          value: tempProductList[index]['newArrival'],
                                                                          onChanged: (value) {
                                                                            setState(() {
                                                                              tempProductList[index]['newArrival'] = !tempProductList[index]['newArrival'];
                                                                              FirebaseFirestore.instance.collection('products').doc(tempProductList[index]['id']).update({
                                                                                "newArrival": tempProductList[index]['newArrival']
                                                                              });
                                                                            });
                                                                          }),
                                                                    ),
                                                                  ),
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
                                                                  ["makeId"] ==
                                                              selectedMake ||
                                                          productList[index][
                                                                  "categoryID"] ==
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
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      width: 20,
                                                                                      height: 20,
                                                                                      child: IconButton(
                                                                                          onPressed: () {
                                                                                            FirebaseFirestore.instance.collection('products').doc(productList[index]['id']).get().then((value) {
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
                                                                                                "pdfUrl": value["pdfUrl"].toString(),
                                                                                                "modelId": value["modelId"]
                                                                                              };
                                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(product)));
                                                                                            });
                                                                                          },
                                                                                          icon: Icon(
                                                                                            Icons.edit,
                                                                                            color: Colors.black87,
                                                                                            size: 12,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 2,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Text(
                                                                                          productList[index]['name'].toString(),
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                                                                        ),
                                                                                        Text(
                                                                                          productList[index]['itemCode'].toString(),
                                                                                          textAlign: TextAlign.center,
                                                                                          style: TextStyle(fontSize: 12, color: Colors.black),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    flex: 1,
                                                                                    child: Container(
                                                                                      width: 20,
                                                                                      height: 20,
                                                                                      child: IconButton(
                                                                                          onPressed: () {
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (_) => AlertDialog(
                                                                                                title: Text(
                                                                                                  ' this product will be deleted, Are You Sure?',
                                                                                                  style: TextStyle(fontSize: 14),
                                                                                                ),
                                                                                                // shape: CircleBorder(),
                                                                                                shape: BeveledRectangleBorder(
                                                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                                                ),
                                                                                                elevation: 30,
                                                                                                backgroundColor: Colors.white,
                                                                                                contentPadding: EdgeInsets.all(5),
                                                                                                actions: <Widget>[
                                                                                                  InkWell(
                                                                                                      onTap: () {
                                                                                                        Navigator.of(context).pop();
                                                                                                      },
                                                                                                      child: Text(
                                                                                                        'No',
                                                                                                        style: TextStyle(fontSize: 20, color: Colors.red[900]),
                                                                                                      )),
                                                                                                  SizedBox(
                                                                                                    height: 30,
                                                                                                  ),
                                                                                                  InkWell(
                                                                                                    onTap: () {
                                                                                                      FirebaseFirestore.instance.collection("products").doc(productList[index]['id']).delete();
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(_delete);
                                                                                                      Navigator.pop(context);
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text('Yes', style: TextStyle(fontSize: 20, color: Colors.green[900])),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          icon: Icon(
                                                                                            Icons.delete,
                                                                                            color: Colors.black87,
                                                                                            size: 12,
                                                                                          )),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Positioned(
                                                                        top: 0,
                                                                        right:
                                                                            0,
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Transform.scale(
                                                                            scale:
                                                                                0.5,
                                                                            child: CupertinoSwitch(
                                                                                value: productList[index]['newArrival'],
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    productList[index]['newArrival'] = !productList[index]['newArrival'];
                                                                                    FirebaseFirestore.instance.collection('products').doc(productList[index]['id']).update({
                                                                                      "newArrival": productList[index]['newArrival']
                                                                                    });
                                                                                  });
                                                                                }),
                                                                          ),
                                                                        ),
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

final _delete = SnackBar(
  content: Text(
    'Deleted Successfully',
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
