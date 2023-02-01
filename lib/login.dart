import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password, _name, _phone, _address;
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  bool wholeSale = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
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
                      child: Center(child: Text('Product Panel'))),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                    width: width * 0.3,
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
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
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
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child:
                                          Center(child: Text('Add New User'))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      labelText: 'Name',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _name = value.trim();
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      labelText: 'Email',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _email = value.trim();
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: '750xxxxxxx',
                                      labelText: '750xxxxxxx',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _phone = value.trim();
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Address',
                                      labelText: 'Address',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _address = value.trim();
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _password = value.trim();
                                      });
                                    },
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        auth
                                            .createUserWithEmailAndPassword(
                                                email: _email,
                                                password: _password)
                                            .then((_user) {
                                          _user.user!.uid.toString();
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(_user.user!.uid.toString())
                                              .set({
                                            "username": _name,
                                            'phone': _phone,
                                            'address': _address,
                                            "email": _email,
                                            'password': _password,
                                            "role": 1
                                          });
                                          setState(() {
                                            _name = "";
                                            _phone = "";
                                            _email = "";
                                            _address = "";
                                            _password = "";
                                          });
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomeScreen()));
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
                                            child: Text('ADD',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Container(
                      width: width * 0.6,
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    wholeSale = !wholeSale;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Container(
                                      width: width * 0.1,
                                      height: height * 0.06,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: !wholeSale
                                                ? [
                                                    Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ]
                                                : [
                                                    Color.fromARGB(
                                                        255, 0, 178, 169),
                                                    Color.fromARGB(
                                                        255, 0, 106, 101),
                                                  ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          border: wholeSale
                                              ? null
                                              : GradientBoxBorder(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color.fromARGB(
                                                        255, 0, 178, 169),
                                                    Color.fromARGB(
                                                        255, 0, 106, 101),
                                                  ]),
                                                  width: 1,
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text(
                                        'Wholesale Users',
                                        style: TextStyle(
                                            color: !wholeSale
                                                ? Colors.black
                                                : Colors.white),
                                      ))),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    wholeSale = !wholeSale;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Container(
                                      width: width * 0.1,
                                      height: height * 0.06,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: wholeSale
                                                ? [
                                                    Color.fromARGB(
                                                        255, 255, 255, 255),
                                                    Color.fromARGB(
                                                        255, 255, 255, 255),
                                                  ]
                                                : [
                                                    Color.fromARGB(
                                                        255, 0, 178, 169),
                                                    Color.fromARGB(
                                                        255, 0, 106, 101),
                                                  ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          border: !wholeSale
                                              ? null
                                              : GradientBoxBorder(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    Color.fromARGB(
                                                        255, 0, 178, 169),
                                                    Color.fromARGB(
                                                        255, 0, 106, 101),
                                                  ]),
                                                  width: 1,
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text(
                                        'Normal Users',
                                        style: TextStyle(
                                            color: wholeSale
                                                ? Colors.black
                                                : Colors.white),
                                      ))),
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder(
                              stream: !wholeSale
                                  ? FirebaseFirestore.instance
                                      .collection('users')
                                      .where("role", isEqualTo: 0)
                                      .snapshots()
                                  : FirebaseFirestore.instance
                                      .collection('users')
                                      .where("role", isEqualTo: 1)
                                      .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                      height: height * 0.5,
                                      child: GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding: EdgeInsets.only(
                                                  top: 15,
                                                  left: 15.0,
                                                  right: 15),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromARGB(
                                                            255, 0, 178, 169),
                                                        Color.fromARGB(
                                                            255, 0, 106, 101),
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ),
                                                    borderRadius:
                                                        const BorderRadius.all(
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
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                child: Center(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                snapshot.data
                                                                    .docs[index]
                                                                    .data()[
                                                                        'username']
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                          .data()['role'] ==
                                                                      1
                                                                  ? Text(
                                                                      snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                              'email']
                                                                          .toString(),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                                  : Text(
                                                                      snapshot
                                                                          .data
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                              'phone']
                                                                          .toString()
                                                                          .replaceAllMapped(
                                                                              RegExp(r'(\d{3})(\d{3})(\d+)'),
                                                                              (Match m) => "(${m[1]}) ${m[2]}-${m[3]}"),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      snapshot.data.docs[index]
                                                                      .data()[
                                                                  'role'] ==
                                                              1
                                                          ? Positioned(
                                                              top: 5,
                                                              right: 5,
                                                              child: IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) =>
                                                                              AlertDialog(
                                                                        title:
                                                                            Text(
                                                                          snapshot.data.docs[index].data()['email'].toString() +
                                                                              '  will be deleted, Are You Sure?',
                                                                          style:
                                                                              TextStyle(fontSize: 14),
                                                                        ),
                                                                        // shape: CircleBorder(),
                                                                        shape:
                                                                            BeveledRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                        ),
                                                                        elevation:
                                                                            30,
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        contentPadding:
                                                                            EdgeInsets.all(5),
                                                                        actions: <
                                                                            Widget>[
                                                                          InkWell(
                                                                              onTap: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Text(
                                                                                'No',
                                                                                style: TextStyle(fontSize: 20, color: Colors.red[900]),
                                                                              )),
                                                                          SizedBox(
                                                                            height:
                                                                                30,
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              FirebaseFirestore.instance.collection("users").doc(snapshot.data.docs[index].id.toString()).delete();
                                                                              ScaffoldMessenger.of(context).showSnackBar(_delete);
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text('Yes', style: TextStyle(fontSize: 20, color: Colors.green[900])),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 16,
                                                                  )),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        },
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              width > width * 0.3 ? 4 : 1,
                                          childAspectRatio: 2,
                                        ),
                                      ));
                                } else {
                                  //<DoretcumentSnapshot> items = snapshot.data;
                                  return Container(child: Text("No data"));
                                }
                              })
                        ],
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
