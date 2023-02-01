import 'dart:html';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/homeScreen.dart';
import 'package:explore/ppdfView.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController nameK = TextEditingController();
  TextEditingController nameA = TextEditingController();
  TextEditingController oemCode = TextEditingController();
  TextEditingController itemCode = TextEditingController();
  TextEditingController barCode = TextEditingController();
  String barcodeT = "";
  TextEditingController brand = TextEditingController();
  TextEditingController piecesInBox = TextEditingController();
  TextEditingController volt = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController descE = TextEditingController();
  TextEditingController descK = TextEditingController();
  TextEditingController descA = TextEditingController();
  TextEditingController cPrice = TextEditingController();
  TextEditingController rPrice = TextEditingController();
  TextEditingController oPrice = TextEditingController();
  TextEditingController wPrice = TextEditingController();
  late String randomNumber;
  var uuid = Uuid();

  List<String> images = [];

  List<QueryDocumentSnapshot> categoryList = [];
  String categoryID = '';
  String image = '';
  bool loading = false;
  bool pdfLoading = false;
  String pdfurl = '';
  String selectedCategory = '';

  List<QueryDocumentSnapshot> makeList = [];
  String selectedMake = '';
  String makeID = '';

  List<QueryDocumentSnapshot> modelList = [];
  String selectedModel = '';
  String modelID = '';

  List<QueryDocumentSnapshot> brandList = [];
  String selectBrand = '';
  String brandId = '';

  late List<Widget> imageSliders = images
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Text(
                            'No. ${images.indexOf(item)} image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  getCategory() {
    FirebaseFirestore.instance.collection('brand').get().then((value) {
      setState(() {
        selectBrand = value.docs[0].data()['name'];
        brandId = value.docs[0].id;
        print(brandId);
      });
      value.docs.forEach((element) {
        setState(() {
          brandList.add(element);
        });
      });
    });

    FirebaseFirestore.instance.collection('categories').get().then((value) {
      setState(() {
        selectedCategory = value.docs[0].data()['name'];
        categoryID = value.docs[0].id;
        print(categoryID);
      });
      value.docs.forEach((element) {
        setState(() {
          categoryList.add(element);
        });
      });
    });
    FirebaseFirestore.instance.collection('make').get().then((value) {
      setState(() {
        selectedMake = value.docs[0].data()['make'];
        makeID = value.docs[0].id;
        print(makeID);
      });
      FirebaseFirestore.instance
          .collection('make')
          .doc(value.docs[0].id)
          .collection("models")
          .get()
          .then((value) {
        setState(() {
          selectedModel = value.docs[0]["mname"];
          value.docs.forEach((element) {
            modelList.add(element);
          });
        });
      });
      value.docs.forEach((element) {
        setState(() {
          modelID = value.docs[0].id;
          print(modelID);
          makeList.add(element);
        });
      });
    });
  }

  final menuProducts = FirebaseFirestore.instance.collection('products');

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getCategory();
    randomNumber = uuid.v1();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("width");
    print(width);
    print("height");
    print(height);
    return Scaffold(body: Builder(
      builder: (BuildContext context) {
        return Container(
          height: height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
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
                                child: Center(child: Text('Product Panel'))),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
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
                              child: Column(
                                children: [
                                  Container(
                                    width: width * 0.2,
                                    height: height * 0.2,
                                    child: images.isEmpty
                                        ? Container(
                                            child:
                                                Center(child: Text("No Data")),
                                          )
                                        : Container(
                                            child: CarouselSlider(
                                            options: CarouselOptions(),
                                            items: images
                                                .map((item) => Container(
                                                      child: Center(
                                                          child: Container(
                                                        margin:
                                                            EdgeInsets.all(5.0),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.0)),
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Image.network(
                                                                    item,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:
                                                                        height *
                                                                            0.2,
                                                                    width: width *
                                                                        0.15),
                                                                Positioned(
                                                                  bottom: 0.0,
                                                                  left: 0.0,
                                                                  right: 0.0,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      gradient:
                                                                          LinearGradient(
                                                                        colors: [
                                                                          Color.fromARGB(
                                                                              100,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                          Color.fromARGB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0)
                                                                        ],
                                                                        begin: Alignment
                                                                            .bottomCenter,
                                                                        end: Alignment
                                                                            .topCenter,
                                                                      ),
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            10.0,
                                                                        horizontal:
                                                                            20.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'No. ${images.indexOf(item) + 1}',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              images.removeAt(images.indexOf(item));
                                                                            });
                                                                            images.indexOf(item);
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      )),
                                                    ))
                                                .toList(),
                                          )),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: width * 0.05,
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
                                              Radius.circular(25.0),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.2),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: Offset(0, 0),
                                              )
                                            ]),
                                        child: InkWell(
                                            onTap: () {
                                              uploadImgToStorage();
                                            },
                                            child: Container(
                                              height: height * 0.05,
                                              width: 25,
                                              child: loading == true
                                                  ? Transform.scale(
                                                      scale: 0.2,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 10,
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.add_a_photo_rounded,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                            )),
                                      ),
                                      InkWell(
                                        child: Container(
                                            width: width * 0.1,
                                            height: height * 0.05,
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
                                                  Radius.circular(25.0),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.green
                                                        .withOpacity(0.2),
                                                    spreadRadius: 4,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 0),
                                                  )
                                                ]),
                                            child: Center(
                                                child: Container(
                                              child: pdfLoading
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text("Done",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Icon(
                                                          Icons.done,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    )
                                                  : Text('Upload PDF',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                            ))),
                                        onTap: () {
                                          pdfLoading
                                              ? null
                                              : uploadPDFToStorage();
                                        },
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Select Category'),
                                      SizedBox(
                                        width: width * 0.0146,
                                      ),
                                      DropdownButton<String>(
                                        // focusColor: Theme.of(context).highlightColor,
                                        //value: _chosenValue,
                                        //elevation: 5,
                                        style: TextStyle(color: Colors.black),
                                        value: selectedCategory,
                                        iconEnabledColor:
                                            Theme.of(context).highlightColor,
                                        items: categoryList
                                            .map<DropdownMenuItem<String>>(
                                                (QueryDocumentSnapshot value) {
                                          return DropdownMenuItem<String>(
                                            value: value['name'].toString(),
                                            child: Text(
                                              value['name'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Text("Choose Category"),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCategory = value.toString();
                                          });
                                          FirebaseFirestore.instance
                                              .collection('categories')
                                              .where("name",
                                                  isEqualTo: value.toString())
                                              .get()
                                              .then((value) {
                                            categoryID = value.docs[0].id;
                                            print(categoryID);
                                          });
                                        },
                                        // onTap: () {
                                        //   setState(() {
                                        //     saveData(_chosenValue);
                                        //   });
                                        // },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: width * 0.0146,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Select Make'),
                                      SizedBox(
                                        width: width * 0.0146,
                                      ),
                                      DropdownButton<String>(
                                        style: TextStyle(color: Colors.black),
                                        value: selectedMake,
                                        iconEnabledColor:
                                            Theme.of(context).highlightColor,
                                        items: makeList
                                            .map<DropdownMenuItem<String>>(
                                                (QueryDocumentSnapshot value) {
                                          return DropdownMenuItem<String>(
                                            value: value['make'].toString(),
                                            child: Text(
                                              value['make'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Text("Choose Make"),
                                        onTap: () {},

                                        onChanged: (value) {
                                          setState(() {
                                            selectedMake = value.toString();
                                          });

                                          FirebaseFirestore.instance
                                              .collection('make')
                                              .where("make",
                                                  isEqualTo: value.toString())
                                              .get()
                                              .then((value) {
                                            makeID = value.docs[0].id;
                                            print(makeID);
                                            FirebaseFirestore.instance
                                                .collection('make')
                                                .doc(value.docs[0].id)
                                                .collection("models")
                                                .get()
                                                .then((value) {
                                              modelList = [];
                                              modelID = value.docs[0].id;
                                              print(modelID);
                                              setState(() {
                                                selectedModel =
                                                    value.docs[0]["mname"];
                                                print(value.docs[0]["mname"]);
                                                value.docs.forEach((element) {
                                                  modelList.add(element);
                                                });
                                              });
                                            });
                                          });
                                        },
                                        // onTap: () {
                                        //   setState(() {
                                        //     saveData(_chosenValue);
                                        //   });
                                        // },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: width * 0.0146,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Select Model'),
                                      SizedBox(
                                        width: width * 0.0146,
                                      ),
                                      DropdownButton<String>(
                                        style: TextStyle(color: Colors.black),
                                        value: selectedModel,
                                        iconEnabledColor:
                                            Theme.of(context).highlightColor,
                                        items: modelList
                                            .map<DropdownMenuItem<String>>(
                                                (QueryDocumentSnapshot value) {
                                          return DropdownMenuItem<String>(
                                            value: value['mname'].toString(),
                                            child: Text(
                                              value['mname'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Text("Choose Model"),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedModel = value.toString();
                                          });

                                          FirebaseFirestore.instance
                                              .collection('make')
                                              .doc(makeID)
                                              .collection("models")
                                              .where("mname",
                                                  isEqualTo: value.toString())
                                              .get()
                                              .then((value) {
                                            modelID = value.docs[0].id;
                                            print(modelID);
                                          });
                                        },
                                        // onTap: () {
                                        //   setState(() {
                                        //     saveData(_chosenValue);
                                        //   });
                                        // },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: width * 0.0146,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Select Brand'),
                                      SizedBox(
                                        width: width * 0.0146,
                                      ),
                                      DropdownButton<String>(
                                        style: TextStyle(color: Colors.black),
                                        value: selectBrand,
                                        iconEnabledColor:
                                            Theme.of(context).highlightColor,
                                        items: brandList
                                            .map<DropdownMenuItem<String>>(
                                                (QueryDocumentSnapshot value) {
                                          return DropdownMenuItem<String>(
                                            value: value['name'].toString(),
                                            child: Text(
                                              value['name'],
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        hint: Text("Choose Brand"),
                                        onChanged: (value) {
                                          setState(() {
                                            selectBrand = value.toString();
                                          });
                                        },
                                        // onTap: () {
                                        //   setState(() {
                                        //     saveData(_chosenValue);
                                        //   });
                                        // },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: width * 0.0146,
                                  ),
                                  Container(
                                    width: width * 0.15,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: width * 0.0146,
                                        ),
                                        InkWell(
                                          child: Container(
                                              width: width * 0.1,
                                              height: height * 0.05,
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
                                                    Radius.circular(25.0),
                                                  ),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.green
                                                          .withOpacity(0.2),
                                                      spreadRadius: 4,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 0),
                                                    )
                                                  ]),
                                              child: Center(
                                                  child: Container(
                                                child: Text('ADD',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )),
                                              ))),
                                          onTap: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (categoryID.isEmpty ||
                                                  image.isEmpty) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(_missingData);
                                              } else {
                                                menuProducts
                                                    .doc(randomNumber)
                                                    .set({
                                                  "categoryID": categoryID,
                                                  'productID':
                                                      randomNumber.toString(),
                                                  "newArrival": false,
                                                  'makeId': makeID,
                                                  'modelId': modelID,
                                                  'name': name.text,
                                                  "images": images,
                                                  'nameK': nameK.text,
                                                  'nameA': nameA.text,
                                                  'desc': descE.text,
                                                  'descK': descK.text,
                                                  'descA': descA.text,

                                                  'oemCode': oemCode
                                                          .text.isEmpty
                                                      ? 0
                                                      : int.parse(oemCode.text
                                                          .toString()),
                                                  'itemCode': int.parse(
                                                      itemCode.text.toString()),
                                                  'barCode': int.parse(
                                                      barCode.text.toString()),
                                                  'piecesInBox': int.parse(
                                                      piecesInBox.text
                                                          .toString()),
                                                  'brand': selectBrand,
                                                  'volt': volt.text,
                                                  "pdfUrl": pdfurl.toString(),
                                                  'quantity': int.parse(
                                                      quantity.text.toString()),
                                                  'cost price':
                                                      int.parse(cPrice.text),
                                                  'retail price':
                                                      int.parse(rPrice.text),
                                                  'old price':
                                                      int.parse(oPrice.text),
                                                  'wholesale price':
                                                      int.parse(wPrice.text),
                                                  "Time": DateTime.now(),
                                                  "img": image,

                                                  // "Time": DateTime.now(),// John Doe
                                                });
                                                setState(() {
                                                  name.text = '';
                                                  nameK.text = '';
                                                  nameA.text = '';
                                                  descE.text = '';
                                                  descK.text = '';
                                                  descA.text = '';
                                                  cPrice.text = '';
                                                  wPrice.text = '';
                                                  images = [];
                                                  pdfLoading = false;
                                                  rPrice.text = '';
                                                  oPrice.text = '';
                                                  image = '';
                                                  brand.text = '';
                                                  oemCode.text = '';
                                                  itemCode.text = '';
                                                  barCode.text = '';
                                                  quantity.text = '';
                                                  volt.text = '';
                                                  piecesInBox.text = '';

                                                  randomNumber = uuid.v1();
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(_success);
                                              }
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: width * 0.0146,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              controller: name,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Enter Product Name";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Name',
                                                labelText: 'Name',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              controller: nameK,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "ناوی کاڵاکە بنووسە";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'ناو',
                                                labelText: 'ناو',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              controller: nameA,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "اكتب اسم البضاعة";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'اسم',
                                                labelText: 'اسم',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                              ),
                                            ),
                                          ),

                                          //description
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.0229,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: TextFormField(
                                              controller: barCode,
                                              onChanged: (text) {
                                                setState(() {
                                                  barcodeT = barCode.text;
                                                });
                                              },
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Enter Barcode";
                                                } else if (val.length != 12) {
                                                  return "Barcode should be 12 numbers";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Enter 12 numbers EAN 13",
                                                labelText: "Bar Code",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 1,
                                            child: Container(),
                                          ),

                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: height * 0.075,
                                              child: BarcodeWidget(
                                                data: barCode.text,
                                                barcode: Barcode.ean13(),
                                                errorBuilder:
                                                    (context, error) => Center(
                                                        child: Text(
                                                            "ean 13 barcode should be 12 number")),
                                              ),
                                            ),
                                          ),

                                          //description
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: height * 0.0229,
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              controller: oemCode,
                                              decoration: InputDecoration(
                                                hintText: 'OEM CODE',
                                                labelText: 'OEM CODE',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.0146,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              controller: itemCode,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Enter Item Code";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Item Code",
                                                labelText: "Item Code",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              controller: piecesInBox,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Enter Pieces In Box";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Pieces In Box",
                                                labelText: "Pieces In Box",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.01,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: TextFormField(
                                              controller: volt,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return "Enter Volt";
                                                } else {
                                                  return null;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                hintText: "Volt",
                                                labelText: "Volt",
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                              ),
                                            ),
                                          ),

                                          //description
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.0229,
                                    ),
                                    TextFormField(
                                      controller: descE,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Product Details";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Description',
                                        labelText: 'Description',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.0229,
                                    ),
                                    TextFormField(
                                      controller: descK,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "وردەکاری کالا";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'وردەکاری',
                                        labelText: 'وردەکاری',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.0229,
                                    ),
                                    TextFormField(
                                      controller: descA,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "تفاصيل السلع";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'وصف',
                                        labelText: 'وصف',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.0229,
                                    ),
                                    //prices
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: width * 0.1,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: cPrice,
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Enter price";
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Cost Price',
                                              labelText: 'Cost Price',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.1,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: oPrice,
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Enter price";
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Old Price',
                                              labelText: 'Old Price',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.1,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: rPrice,
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Enter price";
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: 'Retail Price',
                                              labelText: 'Retail Price',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.1,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: wPrice,
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Enter price";
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: ' Wholesale Price ',
                                              labelText: ' Wholesale Price',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.1,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: quantity,
                                            validator: (val) {
                                              if (val!.isEmpty) {
                                                return "Enter Quantity";
                                              } else {
                                                return null;
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: ' Quantity ',
                                              labelText: ' Quantity',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    ));
  }

  void selectImage({required Function(File file) onSelected}) {
    var uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
        setState(() {
          loading = true;
        });
      });
    });
  }

  void uploadImgToStorage() {
    final dateTime = DateTime.now();
    final name = 'ProductImg';
    final path = '$name/$dateTime';
    selectImage(onSelected: (file) async {
      fb.StorageReference storageRef = fb
          .storage()
          .refFromURL('gs://baharka-library-e410f.appspot.com')
          .child(path);
      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await storageRef.put(file).future;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();

      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          image = imageUri.toString();
          images.add(image);

          loading = false;
        });
      });
    });
  }

  void selectPDF({required Function(File file) onSelected}) {
    var uploadInput = FileUploadInputElement()..accept = '.pdf';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
        setState(() {
          pdfLoading = true;
        });
      });
    });
  }

  void uploadPDFToStorage() {
    final dateTime = DateTime.now();
    final name = 'PDF';
    final path = '$name/$dateTime';
    selectPDF(onSelected: (file) async {
      fb.StorageReference storageRef = fb
          .storage()
          .refFromURL('gs://baharka-library-e410f.appspot.com')
          .child(path);
      fb.UploadTaskSnapshot uploadTaskSnapshot =
          await storageRef.put(file).future;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();

      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          pdfurl = imageUri.toString();

          // pdfLoading = false;
        });
      });
    });
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

  final _missingData = SnackBar(
    content: Text(
      'Category or Image is empty',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 3),
  );
}
