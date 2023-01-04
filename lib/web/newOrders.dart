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

  String userID='';
  String orderID='';
  List<String> productIDs =[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Admin').doc("admindoc").collection("orders")
            .where("OrderStatus",isEqualTo: "Pending")
           // .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {


            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                //scrollDirection: Axis.horizontal,
                itemBuilder: ((context, index) {
                  //productIDs.add(snapshot.data.docs[index]["productID"]);

                  userID= snapshot.data.docs[index]["userID"];
                  orderID= snapshot.data.docs[index]["orderID"];
                  return
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        children: [


                          Container(
                            // height: 175,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        spreadRadius: 1,
                                        blurRadius: 10)
                                  ]),
                              child: Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data.docs[index]
                                        .data()['userName'].toString(),style: TextStyle(color: Colors.green[900],fontSize: 18),),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(vertical:5 ),
                                      child:  Text(snapshot.data.docs[index]
                                          .data()['userPhone'].toString(),style: TextStyle(color: Colors.green[900],fontSize: 14),),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(vertical:7 ),
                                      child: Text(snapshot.data.docs[index]
                                          .data()['date'].toString(),style: TextStyle(fontSize: 12),),
                                    ),
                                    Row(
                                      children: [
                                        Text('Deliver to: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                        Expanded(child: Text(snapshot.data.docs[index]
                                            .data()['userAddress'].toString())),
                                      ],
                                    ),




                                  ],
                                ),
                              )),
                          Positioned(
                           bottom: 40.0,
                            right: 100.0,
                            child: Center(
                              child: InkWell(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>NewOrderDetails(snapshot.data.docs[index],orderID,userID,)
                                  ));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.green[900],
                                    boxShadow:  [
                                      BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(-4, 4),
                                      ),
                                    ],
                                  ),
                                  child: Text('Details',style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight:  FontWeight.bold
                                  ),),
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
        });
  }
}
