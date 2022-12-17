import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:explore/web/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../homeScreen.dart';


// ignore: must_be_immutable
class NewOrderDetails extends StatefulWidget {


  QueryDocumentSnapshot snapshot;
  String orderID;
  String userID;

  NewOrderDetails(this.snapshot,this.orderID,this.userID,);



  @override
  _NewOrderDetailsState createState() => _NewOrderDetailsState();
}

class _NewOrderDetailsState extends State<NewOrderDetails> {

bool loading=false;

  decreaseQuantity(){
loading=true;
    int quantity=0;
    for(int i=0; i<productIDs.length;i++) {
      FirebaseFirestore.instance
          .collection('products').where("productID", isEqualTo: productIDs[i])
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          setState(() {
            quantity =  element['quantity'];
          });
          i++;
        });

      }).whenComplete(() {
        for(int q=0; q<productIDs.length;q++) {
          print('$quantity     quantity');
          print('${widget.snapshot.data()['productList'][q]['quantity'].toString()}    order quantityy');
          print('${quantity - widget.snapshot.data()['productList'][q]['quantity']}    result');

          final test=  quantity - widget.snapshot.data()['productList'][q]['quantity'];
          print('$test  testttt');
          FirebaseFirestore.instance.collection("products").
          doc(productIDs[q]).update({
            "quantity": test,
          });
        }

      });
    }

    Future.delayed(Duration(seconds: 3),(){
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>HomeScreen()
      ));
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.snapshot.data()['totalPrice'].toString());
    print(widget.orderID);
    print(widget.userID);
  }
  late List<DocumentSnapshot> allProductListSnapShot;
  List<String> productIDs=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //height: 400,
        child:  Padding(
          padding:  EdgeInsets.only(bottom: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: 175,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.snapshot
                            .data()['userName'].toString(),style: TextStyle(color: Colors.green[900],fontSize: 18),),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical:5 ),
                          child:  Text(widget.snapshot
                              .data()['userPhone'].toString(),style: TextStyle(color: Colors.green[900],fontSize: 14),),
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(vertical:7 ),
                          child: Text(widget.snapshot
                              .data()['date'].toString(),style: TextStyle(fontSize: 12),),
                        ),
                        Row(
                          children: [
                            Text('Deliver to: ',style: TextStyle(fontWeight: FontWeight.bold),),
                            Expanded(child: Text(widget.snapshot
                                .data()['userAddress'].toString())),
                          ],
                        ),




                      ],
                    )),
                SizedBox(height: 10,),
                Text("Products",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    // color: Colors.red,
                    // margin: EdgeInsets.only(
                    //     left: 15.0),
                    child: ListView.builder(
                        itemCount: widget.snapshot
                            .data()['productList']
                            .length,
                        itemBuilder:
                            (context, i) {
                           productIDs.add( widget.snapshot.data()['productList'][i]["productID"]);
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
                                      Text('${widget.snapshot
                                          .data()['productList'][i]['quantity'].toString()}x'),
                                      SizedBox(width: 10,),
                                      Text(
                                        widget.snapshot.data()['productList'][i]['name'],
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
                ),
                SizedBox(height: 5,),
                Column(children: [

                  Row(
                    children: [
                      Text('Delivery Fee: ',style: TextStyle(fontWeight: FontWeight.bold),),
                      Expanded(child: Text('${widget.snapshot
                          .data()['deliveryFee']}\$')),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Total Price: ',style: TextStyle(fontWeight: FontWeight.bold),),
                      Expanded(child: Text('${widget.snapshot
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

                ],),
                loading==false?
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

                                    FirebaseFirestore.instance.collection("Admin").doc("admindoc").collection("orders").doc(widget.snapshot.id).update({
                                      "OrderStatus":"Accepted",
                                      "date": orderDate,
                                    });

                                    FirebaseFirestore.instance.collection("users").
                                    doc(widget.userID).
                                    collection("orders").
                                    doc(widget.orderID).update({
                                      "OrderStatus":"Accepted",
                                      "date": orderDate,
                                    });
                                    Navigator.of(context).pop();
                                    Future.delayed(Duration(seconds: 1),(){
                                      decreaseQuantity();
                                    });
                                    //
                                    // int quantity=0;
                                    // for(int i=0; i<productIDs.length;i++) {
                                    //   FirebaseFirestore.instance
                                    //       .collection('products').where("productID", isEqualTo: productIDs[i])
                                    //       .get()
                                    //       .then((value) {
                                    //     value.docs.forEach((element) async {
                                    //       setState(() {
                                    //         quantity =  element['quantity'];
                                    //       });
                                    //       i++;
                                    //     });
                                    //
                                    //   }).whenComplete(() {
                                    //     print('${quantity.toString()}  quantityyyyya');
                                    //     for(int q=0; q<productIDs.length;q++) {
                                    //       print('${widget.snapshot.data()['productList'][q]['quantity'].toString()}    quantityy');
                                    //
                                    //       FirebaseFirestore.instance.collection("products").
                                    //       doc(productIDs[q]).update({
                                    //         "quantity": quantity - widget.snapshot.data()['productList'][q]['quantity'],
                                    //       }).whenComplete(() {
                                    //
                                    //         Navigator.of(context).push(MaterialPageRoute(
                                    //             builder: (context) =>HomeScreen()
                                    //         ));
                                    //       });
                                    //     }
                                    //
                                    //   });
                                    // }

                                    // Navigator.of(context).pop();
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

                                    FirebaseFirestore.instance.collection("Admin").doc("admindoc").collection("orders").doc(widget.snapshot.id).update({
                                      "OrderStatus":"Rejected",
                                      "date": orderDate,
                                    });


                                    FirebaseFirestore.instance.collection("users").doc(widget.userID).collection("orders").doc(widget.orderID)
                                        .update({
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
                ):
                    Center(child: CircularProgressIndicator()),
                SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


