import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/homeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: deprecated_member_use
import 'package:firebase/firebase.dart' as fb;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:uuid/uuid.dart';

class AddModel extends StatefulWidget {
  List<dynamic> makes = [];
  AddModel(this.makes) : super();

  @override
  _AddCategoryState createState() => _AddCategoryState(this.makes);
}

final _formKey = GlobalKey<FormState>();
final _formKey2 = GlobalKey<FormState>();

class _AddCategoryState extends State<AddModel> {
  TextEditingController name = TextEditingController();
  TextEditingController nameK = TextEditingController();
  TextEditingController nameA = TextEditingController();

  TextEditingController mname = TextEditingController();
  TextEditingController mnameK = TextEditingController();
  TextEditingController mnameA = TextEditingController();
  late String randomNumber;
  final makeCollection = FirebaseFirestore.instance.collection('make');

  var uuid = Uuid();

  List<dynamic> makes = [];
  dynamic selectedMake;
  bool imgLoad = false;
  String selectedModelId = '';

  _AddCategoryState(this.makes);

  bool makeEdit = false;
  bool modelEdit = false;

  getCats() async {
    setState(() {
      selectedMake = makes[0];
    });
    setState(() {
      imgLoad = true;
    });
  }

  void initState() {
    getCats();

    super.initState();
    randomNumber = uuid.v1();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(body: Builder(
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
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
                              child: Center(child: Text('Models Panel'))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: height * 0.85,
                              padding: EdgeInsets.all(20),
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
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Text("Add Make"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    //name
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              uploadImgToStorage();
                                            },
                                            child: img.isEmpty
                                                ? Container(
                                                    height: height * 0.2,
                                                    child: loading == true
                                                        ? Transform.scale(
                                                            scale: 0.2,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 10,
                                                            ),
                                                          )
                                                        : Icon(Icons
                                                            .add_a_photo_rounded),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0) //                 <--- border radius here
                                                              ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: Image.network(
                                                        img.toString()),
                                                  ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Container(
                                              // width:00,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        width: width * 0.1,
                                                        child: TextFormField(
                                                          controller: name,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "Enter Product Name";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'Name',
                                                            labelText: 'Name',
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
                                                      Container(
                                                        width: width * 0.1,
                                                        child: TextFormField(
                                                          controller: nameK,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "ناوی کاڵاکە بنووسە";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'ناو',
                                                            labelText: 'ناو',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Container(
                                                        width: width * 0.1,
                                                        child: TextFormField(
                                                          controller: nameA,
                                                          validator: (val) {
                                                            if (val!.isEmpty) {
                                                              return "اكتب اسم البضاعة";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: 'اسم',
                                                            labelText: 'اسم',
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
                                                      Container(
                                                        width: width * 0.1,
                                                        child: InkWell(
                                                            onTap: () {
                                                              if (makeEdit) {
                                                                makeCollection
                                                                    .doc(selectedMake[
                                                                        'id'])
                                                                    .update({
                                                                  'make':
                                                                      name.text,
                                                                  'makeK': nameK
                                                                      .text,
                                                                  'makeA': nameA
                                                                      .text,
                                                                  'img': img,
                                                                  "Time":
                                                                      DateTime
                                                                          .now(),

                                                                  // "Time": DateTime.now(),// John Doe
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                              if (_formKey
                                                                      .currentState!
                                                                      .validate() &&
                                                                  !makeEdit) {
                                                                if (image
                                                                    .isEmpty) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          _missingData);
                                                                } else {
                                                                  makeCollection
                                                                      .doc(
                                                                          randomNumber)
                                                                      .set({
                                                                    'make': name
                                                                        .text,
                                                                    'makeK': nameK
                                                                        .text,
                                                                    'makeA': nameA
                                                                        .text,
                                                                    'makeId':
                                                                        randomNumber
                                                                            .toString(),
                                                                    "Time":
                                                                        DateTime
                                                                            .now(),
                                                                    "img":
                                                                        image,
                                                                    // "Time": DateTime.now(),// John Doe
                                                                  });

                                                                  setState(() {
                                                                    name.text =
                                                                        '';
                                                                    nameK.text =
                                                                        '';
                                                                    nameA.text =
                                                                        '';
                                                                    image = '';
                                                                    randomNumber =
                                                                        uuid.v1();
                                                                    img = '';
                                                                    //image='';
                                                                  });
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          _success);
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                                width:
                                                                    width * 0.1,
                                                                height: height *
                                                                    0.05,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Color.fromARGB(
                                                                                255,
                                                                                0,
                                                                                178,
                                                                                169),
                                                                            Color.fromARGB(
                                                                                255,
                                                                                0,
                                                                                106,
                                                                                101),
                                                                          ],
                                                                          begin:
                                                                              Alignment.centerLeft,
                                                                          end: Alignment
                                                                              .centerRight,
                                                                        ),
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              25.0),
                                                                        ),
                                                                        boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .green
                                                                            .withOpacity(0.2),
                                                                        spreadRadius:
                                                                            4,
                                                                        blurRadius:
                                                                            10,
                                                                        offset: Offset(
                                                                            0,
                                                                            0),
                                                                      )
                                                                    ]),
                                                                child: Center(
                                                                    child: makeEdit
                                                                        ? Text('Done',
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                            ))
                                                                        : Text('ADD',
                                                                            style: TextStyle(
                                                                              color: Colors.white,
                                                                            ))))),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text("Makes"),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                  height: height * 0.4,
                                                  child: makes.isEmpty
                                                      ? Center(
                                                          child: Container(
                                                            child: Text(
                                                                "Loading..."),
                                                          ),
                                                        )
                                                      : Container(
                                                          child:
                                                              GridView.builder(
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount:
                                                                makes.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 15,
                                                                        left:
                                                                            15.0,
                                                                        right:
                                                                            15),
                                                                child: selectedMake ==
                                                                        null
                                                                    ? Container()
                                                                    : Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          borderRadius: BorderRadius.only(
                                                                              topLeft: Radius.circular(10),
                                                                              topRight: Radius.circular(10),
                                                                              bottomLeft: Radius.circular(10),
                                                                              bottomRight: Radius.circular(10)),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: selectedMake['make'] == makes[index]['make'] ? Colors.green : Colors.grey.withOpacity(0.5),
                                                                              spreadRadius: 1,
                                                                              blurRadius: 2,
                                                                              offset: Offset(0, 0), // changes position of shadow
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                15),
                                                                        child: ListTile(
                                                                            subtitle: Text(
                                                                              makes[index]['make'],
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            title: InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  selectedMake = makes[index];
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                width: width * 0.1,
                                                                                height: width * 0.1,
                                                                                child: Stack(
                                                                                  children: [
                                                                                    Container(
                                                                                      width: width * 0.1,
                                                                                      height: height * 0.1,
                                                                                      child: Image.network(makes[index]['img'].toString()),
                                                                                    ),
                                                                                    Positioned(
                                                                                        bottom: 0,
                                                                                        child: Container(
                                                                                          //   width: width * 0.08,
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              IconButton(
                                                                                                  onPressed: () {
                                                                                                    setState(() {
                                                                                                      makeEdit = true;

                                                                                                      selectedMake = makes[index];

                                                                                                      name.text = makes[index]['make'].toString();
                                                                                                      nameA.text = makes[index]['makeA'].toString();
                                                                                                      nameK.text = makes[index]['makeK'].toString();
                                                                                                      img = makes[index]['img'].toString();
                                                                                                    });
                                                                                                  },
                                                                                                  icon: Icon(
                                                                                                    Icons.edit,
                                                                                                    size: 16,
                                                                                                  )),
                                                                                              IconButton(
                                                                                                  onPressed: () {
                                                                                                    int length = 0;
                                                                                                    FirebaseFirestore.instance.collection("products").where("makeId", isEqualTo: makes[index]['id'].toString()).get().then((value) {
                                                                                                      length = value.docs.length;
                                                                                                    }).whenComplete(() {
                                                                                                      showDialog(
                                                                                                        context: context,
                                                                                                        builder: (_) => AlertDialog(
                                                                                                          title: Text(
                                                                                                            length.toString() + ' products will be deleted too, Are You Sure?',
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
                                                                                                                FirebaseFirestore.instance.collection("products").where("makeId", isEqualTo: makes[index]['id'].toString()).get().then((value) {
                                                                                                                  value.docs.forEach((element) {
                                                                                                                    FirebaseFirestore.instance.collection("products").doc(element.id).delete();
                                                                                                                  });
                                                                                                                });
                                                                                                                makeCollection.doc(makes[index]['id']).delete();
                                                                                                                ScaffoldMessenger.of(context).showSnackBar(_delete);
                                                                                                                Navigator.pop(context);
                                                                                                                Navigator.pop(context);
                                                                                                              },
                                                                                                              child: Text('Yes', style: TextStyle(fontSize: 20, color: Colors.green[900])),
                                                                                                            )
                                                                                                          ],
                                                                                                        ),
                                                                                                      );
                                                                                                    });
                                                                                                  },
                                                                                                  icon: Icon(
                                                                                                    Icons.delete,
                                                                                                    size: 16,
                                                                                                  ))
                                                                                            ],
                                                                                          ),
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )),
                                                                      ),
                                                              );
                                                            },
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  width > 700
                                                                      ? 5
                                                                      : 1,
                                                              childAspectRatio:
                                                                  1,
                                                            ),
                                                          ),
                                                        )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: height * 0.85,
                              margin: EdgeInsets.all(20),
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
                              child: Center(
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: height * 0.2,
                                        child: Form(
                                          key: _formKey2,
                                          child: Column(
                                            //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),

                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Container(
                                                    child: Text("Add Model"),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              //name
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0),
                                                      child: Container(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(
                                                                  width: width *
                                                                      0.1,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        mname,
                                                                    validator:
                                                                        (val) {
                                                                      if (val!
                                                                          .isEmpty) {
                                                                        return "Enter Product Name";
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'Name',
                                                                      labelText:
                                                                          'Name',
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: width *
                                                                      0.1,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        mnameK,
                                                                    validator:
                                                                        (val) {
                                                                      if (val!
                                                                          .isEmpty) {
                                                                        return "ناوی کاڵاکە بنووسە";
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'ناو',
                                                                      labelText:
                                                                          'ناو',
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Container(
                                                                  width: width *
                                                                      0.1,
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        mnameA,
                                                                    validator:
                                                                        (val) {
                                                                      if (val!
                                                                          .isEmpty) {
                                                                        return "اكتب اسم البضاعة";
                                                                      } else {
                                                                        return null;
                                                                      }
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          'اسم',
                                                                      labelText:
                                                                          'اسم',
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width: width *
                                                                      0.1,
                                                                  child: InkWell(
                                                                      onTap: () {
                                                                        if (modelEdit) {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('make')
                                                                              .doc(selectedMake['id'])
                                                                              .collection('models')
                                                                              .doc(selectedModelId)
                                                                              .update({
                                                                            'mname':
                                                                                mname.text,
                                                                            'mnameK':
                                                                                mnameK.text,
                                                                            'mnameA':
                                                                                mnameA.text,

                                                                            "Time":
                                                                                DateTime.now(),

                                                                            // "Time": DateTime.now(),// John Doe
                                                                          });

                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                        if (_formKey2.currentState!.validate() &&
                                                                            !modelEdit) {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('make')
                                                                              .doc(selectedMake['id'])
                                                                              .collection('models')
                                                                              .doc()
                                                                              .set({
                                                                            'mname':
                                                                                mname.text,
                                                                            'mnameK':
                                                                                mnameK.text,
                                                                            'mnameA':
                                                                                mnameA.text,
                                                                          });
                                                                          setState(
                                                                              () {
                                                                            mname.text =
                                                                                '';
                                                                            mnameK.text =
                                                                                '';
                                                                            mnameA.text =
                                                                                '';
                                                                            image =
                                                                                '';
                                                                            randomNumber =
                                                                                uuid.v1();
                                                                            img =
                                                                                '';
                                                                            //image='';
                                                                          });
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(_success);
                                                                        }
                                                                      },
                                                                      child: Container(
                                                                          width: width * 0.1,
                                                                          height: height * 0.05,
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
                                                                                  color: Colors.green.withOpacity(0.2),
                                                                                  spreadRadius: 4,
                                                                                  blurRadius: 10,
                                                                                  offset: Offset(0, 0),
                                                                                )
                                                                              ]),
                                                                          child: Center(
                                                                              child: modelEdit
                                                                                  ? Text('Done',
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                      ))
                                                                                  : Text('ADD',
                                                                                      style: TextStyle(
                                                                                        color: Colors.white,
                                                                                      ))))),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text("Models"),
                                                ),
                                              ),
                                            ),
                                            Center(
                                                child: selectedMake == null
                                                    ? Container()
                                                    : Container(
                                                        height: height * 0.4,
                                                        child: StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'make')
                                                                .doc(
                                                                    selectedMake[
                                                                        'id'])
                                                                .collection(
                                                                    "models")
                                                                .snapshots(),
                                                            builder: (context,
                                                                AsyncSnapshot
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return Container(
                                                                    child: GridView
                                                                        .builder(
                                                                  scrollDirection:
                                                                      Axis.vertical,
                                                                  itemCount:
                                                                      snapshot
                                                                          .data
                                                                          .docs
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          top:
                                                                              15,
                                                                          left:
                                                                              15.0,
                                                                          right:
                                                                              15),
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            5,
                                                                        color: Colors
                                                                            .white,
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              height * 0.15,
                                                                          // decoration:
                                                                          //     BoxDecoration(
                                                                          //   color:
                                                                          //       Colors.white,
                                                                          //   borderRadius: BorderRadius.only(
                                                                          //       topLeft: Radius.circular(10),
                                                                          //       topRight: Radius.circular(10),
                                                                          //       bottomLeft: Radius.circular(10),
                                                                          //       bottomRight: Radius.circular(10)),
                                                                          //   boxShadow: [
                                                                          //     BoxShadow(
                                                                          //       color: Colors.grey.withOpacity(0.5),
                                                                          //       spreadRadius: 1,
                                                                          //       blurRadius: 2,
                                                                          //       offset: Offset(0, 0), // changes position of shadow
                                                                          //     ),
                                                                          //   ],
                                                                          // ),
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 15),
                                                                          child: Center(
                                                                              child: Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              Expanded(
                                                                                flex: 1,
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    snapshot.data.docs[index].data()['mname'],
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                flex: 1,
                                                                                //   width: width * 0.08,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    IconButton(
                                                                                        onPressed: () {
                                                                                          setState(() {
                                                                                            modelEdit = true;

                                                                                            mname.text = snapshot.data.docs[index].data()['mname'].toString();
                                                                                            mnameA.text = snapshot.data.docs[index].data()['mnameA'].toString();
                                                                                            mnameK.text = snapshot.data.docs[index].data()['mnameK'].toString();
                                                                                            selectedModelId = snapshot.data.docs[index].id.toString();
                                                                                          });
                                                                                        },
                                                                                        icon: Icon(
                                                                                          Icons.edit,
                                                                                          size: 16,
                                                                                        )),
                                                                                    IconButton(
                                                                                        onPressed: () {
                                                                                          int length = 0;
                                                                                          FirebaseFirestore.instance.collection("products").where("modelId", isEqualTo: snapshot.data.docs[index].id).get().then((value) {
                                                                                            length = value.docs.length;
                                                                                          }).whenComplete(() {
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (_) => AlertDialog(
                                                                                                title: Text(
                                                                                                  length.toString() + ' products will be deleted too, Are You Sure?',
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
                                                                                                      FirebaseFirestore.instance.collection("products").where("modelId", isEqualTo: snapshot.data.docs[index].id).get().then((value) {
                                                                                                        value.docs.forEach((element) {
                                                                                                          FirebaseFirestore.instance.collection("products").doc(element.id).delete();
                                                                                                        });
                                                                                                      });
                                                                                                      makeCollection.doc(selectedMake['id']).collection("models").doc(snapshot.data.docs[index].id).delete();
                                                                                                      ScaffoldMessenger.of(context).showSnackBar(_delete);
                                                                                                      Navigator.pop(context);
                                                                                                      Navigator.pop(context);
                                                                                                    },
                                                                                                    child: Text('Yes', style: TextStyle(fontSize: 20, color: Colors.green[900])),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          });
                                                                                        },
                                                                                        icon: Icon(
                                                                                          Icons.delete,
                                                                                          size: 16,
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  gridDelegate:
                                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                                    crossAxisCount:
                                                                        width > width * 0.3
                                                                            ? 4
                                                                            : 1,
                                                                    childAspectRatio:
                                                                        2,
                                                                  ),
                                                                ));
                                                              } else {
                                                                //<DoretcumentSnapshot> items = snapshot.data;
                                                                return Container(
                                                                    child: Text(
                                                                        "No data"));
                                                              }
                                                            }))),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
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

  String img = '';
  void uploadImgToStorage() {
    setState(() {
      img = '';
    });
    final dateTime = DateTime.now();
    final name = 'ProductImg';
    final path = '$name/$dateTime';
    selectImage(onSelected: (file) async {
      fb.StorageReference storageRef = fb
          .storage()
          .refFromURL('gs://baharka-library-e410f.appspot.com/')
          .child(path);
      var uploadTaskSnapshot = await storageRef.put(file).future;
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();

      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          image = imageUri.toString();
          loading = false;
          img = image.toString();
        });
      });
    });
  }

  String image = '';

  bool loading = false;

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

  final _missingData = SnackBar(
    content: Text(
      'Please select an imgae',
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
