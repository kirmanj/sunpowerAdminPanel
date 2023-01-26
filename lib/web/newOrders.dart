import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/web/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../newOrderDetail.dart';

class NewOrders extends StatefulWidget {
  NewOrders({Key? key}) : super(key: key);

  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {
  String userID = '';
  String orderID = '';
  List<String> productIDs = [];
  late QueryDocumentSnapshot snapshotOrder;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc("admindoc")
        .collection("orders")
        .get()
        .then((value) {
      setState(() {
        snapshotOrder = value.docs[0];
      });
    });
    // TODO: implement initState
    super.initState();
  }

  bool loading = false;
  bool queryLoad = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return queryLoad
        ? Card(
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        // height: 175,

                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshotOrder.data()['userName'].toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    queryLoad = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Color.fromARGB(255, 13, 143, 136),
                                ))
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            snapshotOrder.data()['userPhone'].toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            snapshotOrder.data()['date'].toString(),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Deliver to: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Text(snapshotOrder
                                    .data()['userAddress']
                                    .toString())),
                          ],
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Products",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height * 0.2,
                        // color: Colors.red,
                        // margin: EdgeInsets.only(
                        //     left: 15.0),
                        child: ListView.builder(
                            itemCount:
                                snapshotOrder.data()['productList'].length,
                            itemBuilder: (context, i) {
                              productIDs.add(snapshotOrder
                                  .data()['productList'][i]["productID"]
                                  .toString());
                              return SingleChildScrollView(
                                child: Container(
                                  child: Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                          '${snapshotOrder.data()['productList'][i]['quantity'].toString()}x'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        snapshotOrder
                                            .data()['productList'][i]['name']
                                            .toString(),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        snapshotOrder
                                                .data()['productList'][i]
                                                    ['price']
                                                .toStringAsFixed(0)
                                                .replaceAllMapped(
                                                    RegExp(
                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                    (Match m) => '${m[1]},') +
                                            " \$",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Delivery Fee: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Text(
                                    '${snapshotOrder.data()['deliveryFee'].toString()}\$')),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Total Price: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                                child: Text(
                                    '${snapshotOrder.data()['totalPrice'].toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}\S')),
                          ],
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exchanged Rate',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${(snapshotOrder.data()['dinnar'] * 100).floor().toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} IQD',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                    loading == false
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //accept
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Are You Sure?'),
                                      // shape: CircleBorder(),
                                      shape: BeveledRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 30,
                                      backgroundColor: Colors.white,
                                      actions: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red[900]),
                                            )),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection("Admin")
                                                .doc("admindoc")
                                                .collection("orders")
                                                .doc(snapshotOrder.id)
                                                .get()
                                                .then((value) {
                                              value
                                                  .data()?["productList"]
                                                  .forEach((element) {
                                                int quantity = int.parse(
                                                    element['quantity']
                                                        .toString());
                                                FirebaseFirestore.instance
                                                    .collection("products")
                                                    .where('name',
                                                        isEqualTo:
                                                            element['name'])
                                                    .get()
                                                    .then((value) {
                                                  FirebaseFirestore.instance
                                                      .collection("products")
                                                      .doc(value.docs.first.id)
                                                      .update({
                                                    "quantity":
                                                        FieldValue.increment(
                                                            -quantity)
                                                  });
                                                });

                                                print(element);
                                                print(quantity);
                                              });
                                            }).whenComplete(() {
                                              var date = DateTime.now();
                                              var orderDate = DateFormat(
                                                      'MM-dd-yyyy, hh:mm a')
                                                  .format(date);

                                              FirebaseFirestore.instance
                                                  .collection("Admin")
                                                  .doc("admindoc")
                                                  .collection("orders")
                                                  .doc(snapshotOrder.id)
                                                  .update({
                                                "OrderStatus": "Accepted",
                                                "date": orderDate,
                                              });

                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(userID)
                                                  .collection("orders")
                                                  .doc(orderID)
                                                  .update({
                                                "OrderStatus": "Accepted",
                                                "date": orderDate,
                                              });
                                            });
                                            Navigator.pop(context);
                                            setState(() {
                                              queryLoad = false;
                                            });
                                          },
                                          child: Text('Yes',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.green[900])),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 29, 91, 53),
                                          Color.fromARGB(255, 54, 150, 65),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 4,
                                          offset: Offset(0, 3),
                                        )
                                      ]),
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                              //reject
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Are You Sure?'),
                                      // shape: CircleBorder(),
                                      shape: BeveledRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 30,
                                      backgroundColor: Colors.white,
                                      actions: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red[900]),
                                            )),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              var date = DateTime.now();
                                              var orderDate = DateFormat(
                                                      'MM-dd-yyyy, hh:mm a')
                                                  .format(date);

                                              FirebaseFirestore.instance
                                                  .collection("Admin")
                                                  .doc("admindoc")
                                                  .collection("orders")
                                                  .doc(snapshotOrder.id)
                                                  .update({
                                                "OrderStatus": "Rejected",
                                                "date": orderDate,
                                              });

                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(userID)
                                                  .collection("orders")
                                                  .doc(orderID)
                                                  .update({
                                                "OrderStatus": "Rejected",
                                                "date": orderDate,
                                              });
                                              setState(() {
                                                queryLoad = false;
                                              });

                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Text('Yes',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.green[900])),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 247, 23, 53),
                                          Color.fromARGB(255, 234, 110, 123),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.2),
                                          spreadRadius: 4,
                                          blurRadius: 4,
                                          offset: Offset(0, 3),
                                        )
                                      ]),
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),

                              // ),
                            ],
                          )
                        : Center(child: CircularProgressIndicator()),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          )
        : Card(
            elevation: 5,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                width: width * 0.5,
                // height: height * 0.8,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Admin')
                        .doc("admindoc")
                        .collection("orders")
                        .orderBy('date', descending: true)
                        // .where("OrderStatus", isEqualTo: "Pending")
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            //scrollDirection: Axis.horizontal,
                            itemBuilder: ((context, index) {
                              //productIDs.add(snapshot.data.docs[index]["productID"]);

                              userID = snapshot.data.docs[index]["userID"];
                              orderID = snapshot.data.docs[index]["orderID"];
                              return snapshot.data.docs[index]
                                          .data()['OrderStatus']
                                          .toString() !=
                                      "Pending"
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Stack(
                                        children: [
                                          Container(
                                              // height: 175,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .grey.shade300,
                                                        spreadRadius: 2,
                                                        blurRadius: 5)
                                                  ]),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data.docs[index]
                                                              .data()[
                                                                  'userName']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                        SizedBox(width: 25),
                                                        Text(
                                                          snapshot
                                                              .data.docs[index]
                                                              .data()[
                                                                  'OrderStatus']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[900],
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5),
                                                      child: Text(
                                                        snapshot
                                                            .data.docs[index]
                                                            .data()['userPhone']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 7),
                                                      child: Text(
                                                        snapshot
                                                            .data.docs[index]
                                                            .data()['date']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Deliver to: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Expanded(
                                                            child: Text(snapshot
                                                                .data
                                                                .docs[index]
                                                                .data()[
                                                                    'userAddress']
                                                                .toString())),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          Positioned(
                                            bottom: 10,
                                            right: 10,
                                            child: Center(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    snapshotOrder = snapshot
                                                        .data.docs[index];
                                                    queryLoad = true;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
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
                                                        Radius.circular(4.0),
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.green
                                                              .withOpacity(0.2),
                                                          spreadRadius: 4,
                                                          blurRadius: 4,
                                                          offset: Offset(0, 3),
                                                        )
                                                      ]),
                                                  child: Text(
                                                    'Details',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            }));
                      } else {
                        //<DoretcumentSnapshot> items = snapshot.data;
                        return Container(child: EmptyWidget());
                      }
                    }),
              ),
            ),
          );
  }
}
