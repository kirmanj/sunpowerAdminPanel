import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/ppdfView.dart';
import 'package:explore/web/widgets/carousel.dart';

import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

class AddBrand extends StatefulWidget {
  const AddBrand({Key? key}) : super(key: key);

  @override
  _AddBrandState createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController nameK = TextEditingController();
  TextEditingController nameA = TextEditingController();

  late String randomNumber;
  var uuid = Uuid();

  String image = '';
  bool loading = false;
  bool pdfLoading = false;
  String pdfurl = '';

  final brandsLink = FirebaseFirestore.instance.collection('brand');

  List _isHovering = [];
  List _isSelected = [];

  List<Map> brands = [];
  getBrands() {
    FirebaseFirestore.instance.collection('brand').get().then((value) {
      value.docs.forEach((element) async {
        _isHovering.add(false);
        _isSelected.add(false);

        brands.add({
          "name": element.data()['name'],
          'image': element.data()['img'],
          'pdf': element.data()['pdfurl']
        });
      });
      if (_isSelected.length != 0) {
        _isSelected[0] = true;
      }
    }).whenComplete(() {
      setState(() {
        brands = brands;
        _isHovering = _isHovering;
        _isSelected = _isSelected;
      });
    });
  }

  @override
  void initState() {
    getBrands();
    super.initState();
    randomNumber = uuid.v1();
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
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
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
                            child: Center(child: Text('Brand Panel'))),
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
                                    child: image.isEmpty
                                        ? Container(
                                            child:
                                                Center(child: Text("No Data")),
                                          )
                                        : Container(
                                            child: Image.network(image)),
                                  ),
                                  SizedBox(
                                    height: width * 0.01,
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
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
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
                                                BorderRadius.circular(6.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
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
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Expanded(
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
                                                BorderRadius.circular(6.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
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
                                      if (_formKey.currentState!.validate()) {
                                        if (pdfurl.isEmpty || image.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(_missingData);
                                        } else {
                                          brandsLink.doc(randomNumber).set({
                                            "pdfurl": pdfurl,

                                            'name': name.text,

                                            'nameK': nameK.text,
                                            'nameA': nameA.text,

                                            "Time": DateTime.now(),
                                            "img": image,

                                            // "Time": DateTime.now(),// John Doe
                                          });
                                          setState(() {
                                            name.text = '';
                                            nameK.text = '';
                                            nameA.text = '';

                                            pdfLoading = false;
                                            image = "";
                                            pdfurl = "";

                                            randomNumber = uuid.v1();
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(_success);
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(width * 0.0146),
                              child: Container(
                                width: width * 0.7,
                                height: height * 0.8,
                                child: Column(
                                  children: [
                                    brands.isEmpty
                                        ? Container(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(),
                                          )
                                        : DestinationCarousel(
                                            _isHovering, _isSelected, brands)
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
      print(imageUri.toString());
      Future.delayed(Duration(milliseconds: 100), () {
        setState(() {
          image = imageUri.toString();

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
    final filen = 'Brandpdf';
    var brand = name.text.toString();
    final path = '$filen/$brand';
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
          print(pdfurl);
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
      'pdf or Image is empty',
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
