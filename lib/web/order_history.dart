import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/web/widgets/empty.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  late List<DocumentSnapshot> productListSnapShot;
  late int listLength;
  List<dynamic> cancelOrder = [];
  List<dynamic> acceptOrder = [];
  getCancelOrder() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('Admin')
        .doc("admindoc")
        .collection("orders")
        //.where("OrderStatus", isEqualTo: "Rejected")

        .get()
        .then((value) {
      cancelOrder = value.docs;
      setState(() {
        cancelOrder.sort((a, b) {
          var inputFormat = DateFormat('MM-dd-yyyy, hh:mm a');
          var adate = inputFormat.parse(a['date']); // <-- dd/MM 24H format
          var bdate = inputFormat.parse(b['date']);
          return -adate.compareTo(bdate);
        });
      });

      // ignore: deprecated_member_use
      //  productListSnapShot = new List<DocumentSnapshot>(value.docs.length);

      //   value.docs.forEach((element) async {
      //     setState(() {
      //       productListSnapShot[i] = element;
      //       listLength=productListSnapShot.length;
      //
      //     });
      //     i++;
      //
      //   });
    });
  }

  getAcceptOrder() {
    int i = 0;
    FirebaseFirestore.instance
        .collection('Admin')
        .doc("admindoc")
        .collection("orders")
        // .where("OrderStatus", isEqualTo: "Accepted")
        .get()
        .then((value) {
      acceptOrder = value.docs;
      setState(() {
        acceptOrder.sort((a, b) {
          var inputFormat = DateFormat('MM-dd-yyyy, hh:mm a');
          var adate = inputFormat.parse(a['date']); // <-- dd/MM 24H format
          var bdate = inputFormat.parse(b['date']);

          return -adate.compareTo(bdate);
        });
      });
    });
  }

  @override
  void initState() {
    getCancelOrder();
    getAcceptOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: (Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color.fromARGB(255, 13, 143, 136),
                      )),
                ),
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
                    child: Center(child: Text('Orders Panel'))),
              ],
            ),
            Container(
              width: width * 0.95,
              height: height * 0.9,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DefaultTabController(
                      length: 2, // length of tabs
                      initialIndex: 0,
                      child: Container(
                        // color: Colors.red,
                        child: TabBar(
                          indicatorColor: Color.fromARGB(255, 4, 154, 146),
                          indicatorPadding: EdgeInsets.all(0),
                          labelPadding: EdgeInsets.symmetric(horizontal: 300),
                          // indicator: UnderlineTabIndicator(
                          //     borderSide: BorderSide(width: 1.0),
                          //     insets: EdgeInsets.symmetric(horizontal:10.0)
                          // ),
                          //indicatorSize: TabBarIndicatorSize.,//TabBarIndicatorSize(3),
                          onTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          isScrollable: true,
                          labelColor: Colors.black,
                          tabs: [
                            Tab(text: "Accepted"),
                            Tab(text: "Canceled"),
                          ],
                        ),
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey, width: 0.5))),
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: height * 0.7,
                              //color: Colors.red,
                              child: getCurrentPage(),
                            )))
                  ]),
            )
          ],
        )),
      ),
    );
  }

  int selectedIndex = 0;

  getCurrentPage() {
    if (selectedIndex == 1) {
      return (cancelOrder == null || cancelOrder.isEmpty)
          ? EmptyWidget()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: cancelOrder.length,
              itemBuilder: (context, i) {
                return acceptOrder[i]['OrderStatus'] != "Rejected"
                    ? Container()
                    : Card(
                        elevation: 5,
                        color: Colors.white,
                        child: ExpansionTile(
                          iconColor: Colors.red[900],
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(cancelOrder[i]['userName']
                                          .toString())),
                                  // SizedBox(height: 5,),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        cancelOrder[i]['date'],
                                        style: TextStyle(fontSize: 12),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${(cancelOrder[i]['totalPrice']).floor().toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} IQD',
                                        style: TextStyle(fontSize: 12),
                                      )),
                                ],
                              ),
                            )),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    height: 100,
                                    // color: Colors.red,
                                    // margin: EdgeInsets.only(
                                    //     left: 15.0),
                                    child: ListView.builder(
                                        itemCount: cancelOrder[i]["productList"]
                                            .length,
                                        itemBuilder: (context, index) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Text(
                                                          '${cancelOrder[i]["productList"][index]['quantity'].toString()}x'),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Text(
                                                          cancelOrder[i][
                                                                  "productList"]
                                                              [index]['name'],
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                      //SizedBox(width: 30,),
                                                      Expanded(
                                                        flex: 5,
                                                        child: Text(
                                                          '${cancelOrder[i]["productList"][index]['price'].toString()}\$',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Divider(
                                                    color: Colors.grey,
                                                    height: 1,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Sub-total: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Text(
                                            '${cancelOrder[i]['subTotal'].toString()}\$',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Delivery Fee: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Text(
                                            '${cancelOrder[i]['deliveryFee'].toString()}\$',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Exchanged Rate',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          '${(cancelOrder[i]['dinnar'] * 100).floor().toString()} IQD',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Total Price: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Text(
                                            '${cancelOrder[i]['totalPrice'].toString()} IQD',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  Container(
                                    width: 300,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(
                                      color: Colors.grey,
                                      height: 1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            'User Name: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Text(
                                              '${cancelOrder[i]['userName'].toString()}')),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Phone',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          '${cancelOrder[i]['userPhone']}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Text(
                                            'Address: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Expanded(
                                          flex: 5,
                                          child: Text(
                                              '${cancelOrder[i]['userAddress'].toString()}')),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                // : EmptyWidget();
              });
    } else if (selectedIndex == 0) {
      return
          // ignore: unnecessary_null_comparison
          (acceptOrder == null || acceptOrder.isEmpty)
              ? EmptyWidget()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: acceptOrder.length,
                  itemBuilder: (context, i) {
                    return acceptOrder[i]['OrderStatus'] != "Accepted"
                        ? Container()
                        : Card(
                            elevation: 5,
                            color: Colors.white,
                            child: ExpansionTile(
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Text(acceptOrder[i]['userName']
                                              .toString())),
                                      // SizedBox(height: 5,),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            acceptOrder[i]['date'],
                                            style: TextStyle(fontSize: 12),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            '${(acceptOrder[i]['totalPrice']).floor().toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} IQD',
                                            style: TextStyle(fontSize: 12),
                                          )),
                                    ],
                                  ),
                                )),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 10),
                                        height: 100,
                                        // color: Colors.red,
                                        // margin: EdgeInsets.only(
                                        //     left: 15.0),
                                        child: ListView.builder(
                                            itemCount: acceptOrder[i]
                                                    ["productList"]
                                                .length,
                                            itemBuilder: (context, index) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Text(
                                                              '${acceptOrder[i]["productList"][index]['quantity'].toString()}x'),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              acceptOrder[i][
                                                                      "productList"]
                                                                  [
                                                                  index]['name'],
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          //SizedBox(width: 30,),
                                                          Expanded(
                                                            flex: 5,
                                                            child: Text(
                                                              '${acceptOrder[i]["productList"][index]['price'].toString()}\$',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Divider(
                                                        color: Colors.grey,
                                                        height: 1,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Sub-total: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                '${acceptOrder[i]['subTotal'].toString()}\$',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Delivery Fee: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                '${acceptOrder[i]['deliveryFee'].toString()}\$',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Exchanged Rate',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              '${(acceptOrder[i]['dinnar'] * 100).floor().toString()} IQD',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Total Price: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                '${acceptOrder[i]['totalPrice'].toString()} IQD',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        ],
                                      ),
                                      Container(
                                        width: 300,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                'User Name: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                  '${acceptOrder[i]['userName'].toString()}')),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Phone',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              '${acceptOrder[i]['userPhone']}',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                'Address: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Expanded(
                                              flex: 5,
                                              child: Text(
                                                  '${acceptOrder[i]['userAddress'].toString()}')),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                  });
    }
  }
}
