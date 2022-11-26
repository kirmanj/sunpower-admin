import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/web/widgets/empty.dart';
import 'package:explore/web/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewOrders extends StatefulWidget {
   NewOrders({Key? key}) : super(key: key);

  @override
  _NewOrdersState createState() => _NewOrdersState();
}

class _NewOrdersState extends State<NewOrders> {

  String userID='';
  String orderID='';


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
                  userID= snapshot.data.docs[index]["userID"];
                  orderID= snapshot.data.docs[index]["orderID"];
                  return
                    ExpansionTile(title: Padding(
                      padding:  EdgeInsets.only(bottom: 20),
                      child: Container(
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
                    ),
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 20),
                          child: Column(children: [
                            Container(
                              height: 60,
                              // color: Colors.red,
                              // margin: EdgeInsets.only(
                              //     left: 15.0),
                              child: ListView.builder(
                                  itemCount: snapshot.data.docs[index]
                                      .data()['productList']
                                      .length,
                                  itemBuilder:
                                      (context, i) {
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
                                                Text('${snapshot.data.docs[index]
                                                    .data()['productList'][i]['quantity'].toString()}x'),
                                                SizedBox(width: 10,),
                                                Text(
                                                  snapshot.data.docs[index]
                                                      .data()['productList'][i]['name'],
                                                  style:
                                                  TextStyle(fontSize: 14
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5,),

                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Row(
                              children: [
                                Text('Delivery Fee: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                Expanded(child: Text('${snapshot.data.docs[index]
                                    .data()['deliveryFee']}\$')),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Total Price: ',style: TextStyle(fontWeight: FontWeight.bold),),
                                Expanded(child: Text('${snapshot.data.docs[index]
                                    .data()['totalPrice']}\S')),
                              ],
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Exchanged Rate',
                                  style: TextStyle(fontWeight: FontWeight.bold),

                                ),
                                SizedBox(width: 10,),
                                // Text('${(snapshot.data.docs[index]
                                //     .data()['dinner']*100).floor().toString()} IQD',
                                //   style: TextStyle(fontSize: 13,),
                                // ),
                              ],
                            ),

                            SizedBox(height: 30,),
                            Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //accept
                                InkWell(
                                  onTap: (){
                                    showDialog(context:context,
                                      builder: (_)=>  AlertDialog(title: Text('Are You Sure?'),
                                        // shape: CircleBorder(),
                                        shape: BeveledRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        elevation: 30,
                                        backgroundColor: Colors.white,
                                        actions: <Widget>[

                                           InkWell(
                                        onTap:(){
                                      Navigator.of(context).pop();
                                      },

                                               child: Text('No',style: TextStyle(fontSize: 20,color: Colors.red[900]),)),
                                          SizedBox(height: 30,),

                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                var date =  DateTime.now();
                                                var orderDate = DateFormat('MM-dd-yyyy, hh:mm a').format(date);

                                                FirebaseFirestore.instance.collection("Admin").doc("admindoc").collection("orders").doc(snapshot.data.docs[index].id).update({
                                                  "OrderStatus":"Accepted",
                                                  "date": orderDate,
                                                });

                                                FirebaseFirestore.instance.collection("users").
                                                doc(userID).
                                                collection("orders").
                                                doc(orderID).update({
                                                  "OrderStatus":"Accepted",
                                                  "date": orderDate,
                                                });
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text('Yes',style: TextStyle(fontSize: 20,color: Colors.green[900])),
                                          )
                                        ],
                                      ),
                                    );

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
                                    child: Text('Accept',style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight:  FontWeight.bold
                                    ),),
                                  ),
                                ),


                             //reject
                                InkWell(
                                  onTap: (){
                                    showDialog(context:context,
                                      builder: (_)=>  AlertDialog(title: Text('Are You Sure?'),
                                        // shape: CircleBorder(),
                                        shape: BeveledRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        elevation: 30,
                                        backgroundColor: Colors.white,
                                        actions: <Widget>[

                                          InkWell(
                                              onTap:(){
                                                Navigator.of(context).pop();
                                              },

                                              child: Text('No',style: TextStyle(fontSize: 20,color: Colors.red[900]),)),
                                          SizedBox(height: 30,),

                                          InkWell(
                                            onTap: (){
                                              setState(() {
                                                var date =  DateTime.now();
                                                var orderDate = DateFormat('MM-dd-yyyy, hh:mm a').format(date);

                                                FirebaseFirestore.instance.collection("Admin").doc("admindoc").collection("orders").doc(snapshot.data.docs[index].id).update({
                                                  "OrderStatus":"Rejected",
                                                  "date": orderDate,
                                                });

                                                FirebaseFirestore.instance.collection("users").
                                                doc(userID).
                                                collection("orders").
                                                doc(orderID).update({
                                                  "OrderStatus":"Rejected",
                                                  "date": orderDate,
                                                });
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text('Yes',style: TextStyle(fontSize: 20,color: Colors.green[900])),
                                          )
                                        ],
                                      ),
                                    );

                                  },

                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.red[900],
                                      boxShadow:  [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 1,
                                          blurRadius: 7,
                                          offset: Offset(-4, 4),
                                        ),
                                      ],
                                    ),
                                    child: Text('Reject',style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight:  FontWeight.bold
                                    ),),
                                  ),
                                ),


                                // ),
                              ],
                            ),
                            SizedBox(height: 30,),
                          ],),
                        )

                      ],
                    );


                }));
          } else {
            //<DoretcumentSnapshot> items = snapshot.data;
            return Container(child: EmptyWidget());
          }
        });
  }
}
