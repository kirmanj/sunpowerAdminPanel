import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: deprecated_member_use
import 'package:firebase/firebase.dart' as fb;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:uuid/uuid.dart';

class AddModel extends StatefulWidget {
  const AddModel({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
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
  final categoryCollection = FirebaseFirestore.instance.collection('make');

  CollectionReference model = FirebaseFirestore.instance
      .collection("make")
      .doc("0b431ae0-3ec5-11ed-b639-57f35904df14")
      .collection('models');
  var uuid = Uuid();
  List<dynamic> categories = [];
  dynamic selectedCategory;
  bool imgLoad = false;

  getCats() async {
    FirebaseFirestore.instance.collection("make").get().then((value) {
      int i = 0;
      setState(() {
        categories = value.docs;
      });
      value.docs.forEach((element) async {
        Reference storage =
            FirebaseStorage.instance.ref().child(element['img']);
        String url = await storage.getDownloadURL();
        if (element['make'] == categories[0]['make']) {
          setState(() {
            selectedCategory = element;
          });
        }
        setState(() {
          categories[i] = {
            'make': element['make'],
            'img': url,
            'id': element.id
          };
        });

        i++;
      });

      if (i + 1 == value.docs.length) {
        setState(() {
          imgLoad = true;
        });
      }
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
                          child: Center(child: Text('Categories Panel'))),
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
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                if (image
                                                                    .isEmpty) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          _missingData);
                                                                } else {
                                                                  categoryCollection
                                                                      .doc(
                                                                          randomNumber)
                                                                      .set({
                                                                    'make': name
                                                                        .text,
                                                                    'makeK': nameK
                                                                        .text,
                                                                    'makeA': nameA
                                                                        .text,
                                                                    'categoryID':
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
                                                                            const BorderRadius
                                                                                .all(
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
                                                                    child: Text(
                                                                        'ADD',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
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
                                                  child: categories.isEmpty
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
                                                                categories
                                                                    .length,
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
                                                                child: selectedCategory ==
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
                                                                              color: selectedCategory['make'] == categories[index]['make'] ? Colors.green : Colors.grey.withOpacity(0.5),
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
                                                                              categories[index]['make'],
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                            title: InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  selectedCategory = categories[index];
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                width: width * 0.1,
                                                                                height: width * 0.1,
                                                                                child: Image.network(categories[index]['img'].toString()),
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
                                                                        if (_formKey2
                                                                            .currentState!
                                                                            .validate()) {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('make')
                                                                              .doc(selectedCategory.id)
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
                                                                              child: Text('ADD',
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
                                                child: selectedCategory == null
                                                    ? Container()
                                                    : Container(
                                                        height: height * 0.4,
                                                        child: StreamBuilder(
                                                            stream: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'make')
                                                                .doc(
                                                                    selectedCategory
                                                                        .id)
                                                                .collection(
                                                                    "models")
                                                                .snapshots(),
                                                            builder: (context,
                                                                AsyncSnapshot
                                                                    snapshot) {
                                                              print("test");

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
                                                                            Container(
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
                                                                                color: Colors.grey.withOpacity(0.5),
                                                                                spreadRadius: 1,
                                                                                blurRadius: 2,
                                                                                offset: Offset(0, 0), // changes position of shadow
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          margin:
                                                                              EdgeInsets.only(bottom: 15),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              snapshot.data.docs[index].data()['mname'],
                                                                              textAlign: TextAlign.center,
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
    final dateTime = DateTime.now();
    final name = 'ProductImg';
    final path = '$name/$dateTime';
    selectImage(onSelected: (file) async {
      fb.StorageReference storageRef = fb
          .storage()
          .refFromURL('gs://resturant-management-f42e5.appspot.com')
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
