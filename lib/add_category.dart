import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: deprecated_member_use
import 'package:firebase/firebase.dart' as fb;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:uuid/uuid.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

final _formKey = GlobalKey<FormState>();

class _AddCategoryState extends State<AddCategory> {
  TextEditingController name = TextEditingController();
  TextEditingController nameK = TextEditingController();
  TextEditingController nameA = TextEditingController();

  String selectedCategory = '';
  bool categoryEdit = false;
  late String randomNumber;
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  var uuid = Uuid();
  List<dynamic> categories = [];
  List<dynamic> categoriesTemp = [];
  bool imgLoad = false;
  getCats() async {
    FirebaseFirestore.instance.collection("categories").get().then((value) {
      int i = 0;
      setState(() {
        categoriesTemp = value.docs;
      });
      value.docs.forEach((element) async {
        Reference storage =
            FirebaseStorage.instance.ref().child(element['img']);
        String url = await storage.getDownloadURL();
        setState(() {
          categories.add({
            'name': element['name'],
            'nameA': element['nameA'],
            'nameK': element['nameK'],
            'img': url,
            'id': element.id
          });
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
                              child: Center(child: Text('Categories Panel'))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: height * 0.8,
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
                                          child: Text("Add Category"),
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
                                                    height: 250,
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
                                                const EdgeInsets.only(left: 20),
                                            child: Container(
                                              // width:00,
                                              child: Column(
                                                children: [
                                                  TextFormField(
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
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
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
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  TextFormField(
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
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
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
                                    InkWell(
                                        onTap: () {
                                          if (categoryEdit) {
                                            categoryCollection
                                                .doc(selectedCategory)
                                                .update({
                                              'name': name.text,
                                              'nameK': nameK.text,
                                              'nameA': nameA.text,

                                              // "Time": DateTime.now(),// John Doe
                                            });
                                            Navigator.pop(context);
                                          }
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              !categoryEdit) {
                                            if (image.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(_missingData);
                                            } else {
                                              categoryCollection
                                                  .doc(randomNumber)
                                                  .set({
                                                'name': name.text,
                                                'nameK': nameK.text,
                                                'nameA': nameA.text,
                                                'categoryID':
                                                    randomNumber.toString(),
                                                "Time": DateTime.now(),
                                                "img": image,
                                                // "Time": DateTime.now(),// John Doe
                                              });
                                              setState(() {
                                                name.text = '';
                                                nameK.text = '';
                                                nameA.text = '';
                                                image = '';
                                                randomNumber = uuid.v1();
                                                img = '';
                                                //image='';
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(_success);
                                              Navigator.pop(context);
                                            }
                                          }
                                        },
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
                                                child: categoryEdit
                                                    ? Text('Done',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ))
                                                    : Text('ADD',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ))))),

                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: height * 0.8,
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
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Text("Categories"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Container(
                                          height: height * 0.7,
                                          child: categories.isEmpty
                                              ? Center(
                                                  child: Container(
                                                    child: Text("Loading..."),
                                                  ),
                                                )
                                              : Container(
                                                  child: GridView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        categories.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 15,
                                                                left: 15.0,
                                                                right: 15),
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            10),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            10),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            10),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            10)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .withOpacity(
                                                                            0.5),
                                                                    spreadRadius:
                                                                        1,
                                                                    blurRadius:
                                                                        2,
                                                                    offset: Offset(
                                                                        0,
                                                                        0), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          15),
                                                              child: ListTile(
                                                                  subtitle:
                                                                      Text(
                                                                    categories[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  title:
                                                                      Container(
                                                                    width:
                                                                        width *
                                                                            0.1,
                                                                    height:
                                                                        width *
                                                                            0.1,
                                                                    child: Image.network(categories[index]
                                                                            [
                                                                            'img']
                                                                        .toString()),
                                                                  )),
                                                            ),
                                                            Positioned(
                                                                bottom: 25,
                                                                right: 0,
                                                                child:
                                                                    Container(
                                                                  //   width: width * 0.08,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              categoryEdit = true;

                                                                              selectedCategory = categories[index]['id'].toString();
                                                                              name.text = categories[index]['name'].toString();
                                                                              nameA.text = categories[index]['nameA'].toString();
                                                                              nameK.text = categories[index]['nameK'].toString();
                                                                              img = categories[index]['img'].toString();
                                                                            });
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.edit,
                                                                            size:
                                                                                16,
                                                                          )),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            int length =
                                                                                0;
                                                                            FirebaseFirestore.instance.collection("products").where("categoryID", isEqualTo: categories[index]['id'].toString()).get().then((value) {
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
                                                                                        FirebaseFirestore.instance.collection("products").where("categoryID", isEqualTo: categories[index]['id'].toString()).get().then((value) {
                                                                                          value.docs.forEach((element) {
                                                                                            FirebaseFirestore.instance.collection("products").doc(element.id).delete();
                                                                                          });
                                                                                        });
                                                                                        categoryCollection.doc(categories[index]['id'].toString()).delete();
                                                                                        ScaffoldMessenger.of(context).showSnackBar(_delete);
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text('Yes', style: TextStyle(fontSize: 20, color: Colors.green[900])),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            });
                                                                          },
                                                                          icon:
                                                                              Icon(
                                                                            Icons.delete,
                                                                            size:
                                                                                16,
                                                                          ))
                                                                    ],
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          width > 700 ? 3 : 1,
                                                      childAspectRatio: 1,
                                                    ),
                                                  ),
                                                )),
                                    ),
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
