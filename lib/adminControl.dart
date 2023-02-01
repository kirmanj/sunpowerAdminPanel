import 'dart:html';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/homeScreen.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:uuid/uuid.dart';

class AdminControl extends StatefulWidget {
  final List offerImages;
  final List slideImages;
  final int deliveryFee;
  final int dinnar;
  AdminControl(
      this.offerImages, this.slideImages, this.deliveryFee, this.dinnar);

  @override
  _AdminControlState createState() => _AdminControlState();
}

class _AdminControlState extends State<AdminControl> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController deliveryFee = new TextEditingController();
  TextEditingController dinnar = new TextEditingController();
  List images = [];
  List sliders = [];
  List<QueryDocumentSnapshot> categoryList = [];

  String image = '';
  bool loading = false;

  bool deliveryHandle = false;
  bool exchange = false;

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

  late List<Widget> slideSlider = sliders
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
                            'No. ${sliders.indexOf(item)} image',
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
  @override
  void initState() {
    setState(() {
      images = widget.offerImages;
      sliders = widget.slideImages;
      deliveryFee.text = widget.deliveryFee.toString();
      dinnar.text = widget.dinnar.toString();
    });
    // TODO: implement initState

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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width * 0.4,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
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
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child:
                                          Center(child: Text(' Web Slider'))),
                                  Container(
                                    width: width * 0.3,
                                    height: height * 0.4,
                                    child: sliders.isEmpty
                                        ? Container(
                                            child:
                                                Center(child: Text("No Data")),
                                          )
                                        : Container(
                                            child: CarouselSlider(
                                            options: CarouselOptions(),
                                            items: sliders
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
                                                                            0.4,
                                                                    width: width *
                                                                        0.25),
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
                                                                          'No. ${sliders.indexOf(item) + 1}',
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
                                                                              sliders.removeAt(sliders.indexOf(item));
                                                                            });
                                                                            sliders.indexOf(item);
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
                                  Container(
                                    width: width * 0.05,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 178, 169),
                                            Color.fromARGB(255, 0, 106, 101),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(25.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.2),
                                            spreadRadius: 4,
                                            blurRadius: 10,
                                            offset: Offset(0, 0),
                                          )
                                        ]),
                                    child: InkWell(
                                        onTap: () {
                                          uploadImgToStorageS();
                                        },
                                        child: Container(
                                          height: height * 0.05,
                                          width: 25,
                                          child: sliderLoading == true
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
                                          child: Text('Done',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ))),
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('Admin')
                                          .doc("admindoc")
                                          .update({"sliderImages": sliders});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_success);
                                    },
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.4,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
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
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(child: Text(' Offers'))),
                                  Container(
                                    width: width * 0.3,
                                    height: height * 0.4,
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
                                                                            0.4,
                                                                    width: width *
                                                                        0.25),
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
                                  Container(
                                    width: width * 0.05,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 178, 169),
                                            Color.fromARGB(255, 0, 106, 101),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(25.0),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.green.withOpacity(0.2),
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
                                          child: Text('Done',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ))),
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('Admin')
                                          .doc("admindoc")
                                          .update({"offerImages": images});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(_success);
                                    },
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: width * 0.15,
                              height: height * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
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
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Delivery Fee Price"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: !deliveryHandle
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0),
                                                          child: Text(
                                                              deliveryFee.text +
                                                                  "\$"),
                                                        )
                                                      : TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller:
                                                              deliveryFee,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "Enter price";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          // onChanged: (val) {
                                                          //   deliveryFee.text = '';
                                                          //   deliveryFee.text = val + "\$";
                                                          // },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Enter Price',
                                                            labelText:
                                                                'Enter Price',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.0),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(
                                                              255, 0, 178, 169),
                                                          Color.fromARGB(
                                                              255, 0, 106, 101),
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(5.0),
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
                                                        setState(() {
                                                          deliveryHandle =
                                                              !deliveryHandle;
                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Admin')
                                                            .doc("admindoc")
                                                            .update({
                                                          "deliveryfee":
                                                              int.parse(
                                                                  deliveryFee
                                                                      .text)
                                                        });
                                                      },
                                                      child: !deliveryHandle
                                                          ? Container(
                                                              height:
                                                                  height * 0.06,
                                                              width: 25,
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                            )
                                                          : Container(
                                                              height:
                                                                  height * 0.06,
                                                              width: 25,
                                                              child: Icon(
                                                                Icons.done,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                            )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
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
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Exchange Rate Price"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: !exchange
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0),
                                                          child: Text(
                                                              dinnar.text +
                                                                  " IQD"),
                                                        )
                                                      : TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          controller: dinnar,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "Enter price";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          // onChanged: (val) {
                                                          //   deliveryFee.text = '';
                                                          //   deliveryFee.text = val + "\$";
                                                          // },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                'Enter Price',
                                                            labelText:
                                                                'Enter Price',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6.0),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color.fromARGB(
                                                              255, 0, 178, 169),
                                                          Color.fromARGB(
                                                              255, 0, 106, 101),
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(5.0),
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
                                                        setState(() {
                                                          exchange = !exchange;
                                                        });
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Admin')
                                                            .doc("admindoc")
                                                            .update({
                                                          "dinnar": int.parse(
                                                              dinnar.text)
                                                        });
                                                      },
                                                      child: !exchange
                                                          ? Container(
                                                              height:
                                                                  height * 0.06,
                                                              width: 25,
                                                              child: Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                            )
                                                          : Container(
                                                              height:
                                                                  height * 0.06,
                                                              width: 25,
                                                              child: Icon(
                                                                Icons.done,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ),
                                                            )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
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

  void selectSlide({required Function(File file) onSelected}) {
    var uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
        setState(() {
          sliderLoading = true;
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

  bool sliderLoading = false;

  void uploadImgToStorageS() {
    final dateTime = DateTime.now();
    final name = 'ProductImg';
    final path = '$name/$dateTime';
    selectSlide(onSelected: (file) async {
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
          sliders.add(image);

          sliderLoading = false;
        });
      });
    });
  }

  final _success = SnackBar(
    content: Text(
      'Uppdated Successfully',
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
