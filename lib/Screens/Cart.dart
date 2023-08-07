import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NoCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ///***If you have exported images you must have to copy those images in assets/images directory.
            Image(
              image: NetworkImage(
                  "https://image.freepik.com/free-vector/no-data-concept-illustration_114360-2506.jpg"),
              height: 140,
              width: 140,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Text(
                "The Basket is empty :-(",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: Color(0xff000000),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Text(
                "Your basket will help you to buy several app at once!.",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff727272),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: MaterialButton(
                onPressed: () {},
                color: Color(0xff3a57e8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26.0),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  "ADD FIRST PRODUCT",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xffffffff),
                height: 45,
                minWidth: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseAuth user = FirebaseAuth.instance;
  Map<String, dynamic>? paymentIntent;
  late BuildContext cntext;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int total = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      total;
    });
  }

  sendNotification1(String title, String token, String price) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': 1,
      'status': 'done',
      'message': title
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAxEir0ZA:APA91bEjKav5v9gOfz-abN9-zuQwE2LKFQ8wT-cKwoHUTYCUxB3162YVY8j4hX3fGNAy23Qd07vXYmxipYst-RDQV3xvENgJ5DWH2JfxXk_Pl7qNJnVx3DAtZ9_fFmQ3nKC_UqcG0-jH'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'Booking done of  Rs $price'
                },
                'priority': 'high',
                'data': data,
                'to': token
              }));

      if (response.statusCode == 200) {
        print("Notification has been send");
      } else {
        print("Somethin went wrong");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('app')
        .doc('bookings')
        .collection('cart')
        .doc('request')
        .collection('${user.currentUser!.uid}');
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Color(0xff3a57e8),
          title: Text(
            "Cart",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            Container(
              child: TextButton(
                child: Text(
                  'Tap to Pay',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  await makePayment();
                },
              ),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: collectionReference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading');
            }
            if (snapshot.data!.docs == null) {
              return NoCartScreen();
            }
            total = 0;

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                int price = snapshot.data!.docs[index].get('price');
                total += price;
                return CartItem(
                  title: snapshot.data!.docs[index].get('name'),
                  image: snapshot.data!.docs[index].get('image'),
                  price: snapshot.data!.docs[index].get('price'),
                  id: snapshot.data!.docs[index].get('id'),
                  total: total,
                );
              },
            );
          },
        ));
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('${total}', 'PKR');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Anas'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        await firestore
            .collection('app')
            .doc('bookings')
            .collection('cart')
            .doc('request')
            .collection('${user.currentUser!.uid}')
            .doc('hotel')
            .delete();
        await firestore
            .collection('app')
            .doc('bookings')
            .collection('cart')
            .doc('request')
            .collection('${user.currentUser!.uid}')
            .doc('flight')
            .delete();
        await firestore
            .collection('app')
            .doc('bookings')
            .collection('cart')
            .doc('request')
            .collection('${user.currentUser!.uid}')
            .doc('transport')
            .delete();
        await firestore
            .collection('app')
            .doc('bookings')
            .collection('admin')
            .doc('request')
            .collection('${user.currentUser!.uid}')
            .doc('request')
            .update({'status': 'success', 'totalPrice': total});
        // await firestore
        //     .collection('app')
        //     .doc('bookings')
        //     .collection('${user.currentUser!.uid}')
        //     .doc('hotel')
        //     .update({'status': 'success'});
        // await firestore
        //     .collection('app')
        //     .doc('bookings')
        //     .collection('${user.currentUser!.uid}')
        //     .doc('transport')
        //     .update({'status': 'success'});
        var usertoken = await firestore
            .collection('app')
            .doc('Users')
            .collection('Signup')
            .doc(user.currentUser!.uid)
            .get();
        var token = await usertoken.data()?['token'];

        sendNotification1("Booking done!", token, '$total');

        showDialog(
            context: cntext,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: cntext,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51Mv69yHAyrQONTKf6RNMCzh0YPsHhwP47WL1Y4WQrgqDpj4kFCYSykjaHUDOOYfHbKhLdLxILgkrtS2zlsJROlw700KOaM9Qlr',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}

class CartItem extends StatefulWidget {
  final String title;
  final String image;
  final int price;
  final String id;
  late final int total;

  CartItem(
      {Key? key,
      required this.image,
      required this.title,
      required this.price,
      required this.id,
      required this.total})
      : super(key: key);

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.image),
        ),
        title: Text(widget.title),
        subtitle: Text('Rs${widget.price}'),
        onTap: () {
          print(widget.id);
          if (widget.id.isNotEmpty) {
            if (widget.id.startsWith('fl')) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete'),
                      content: Text('Do you want to Delete ${widget.title}'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance;
                            await FirebaseFirestore.instance
                                .collection('app')
                                .doc('bookings')
                                .collection('cart')
                                .doc('request')
                                .collection('${user.currentUser!.uid}')
                                .doc('flight')
                                .delete();

                            Navigator.of(context).pop();
                            setState(() {
                              totalpricesub(widget.total, widget.price);
                            });
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  });
            }
            if (widget.id.startsWith('ho')) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete'),
                      content: Text('Do you want to Delete ${widget.title}'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance;
                            await FirebaseFirestore.instance
                                .collection('app')
                                .doc('bookings')
                                .collection('cart')
                                .doc('request')
                                .collection('${user.currentUser!.uid}')
                                .doc('hotel')
                                .delete();

                            Navigator.of(context).pop();
                            setState(() {
                              totalpricesub(widget.total, widget.price);
                            });
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  });
            }
            if (widget.id.startsWith('tr')) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete'),
                      content: Text('Do you want to Delete ${widget.title}'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance;
                            await FirebaseFirestore.instance
                                .collection('app')
                                .doc('bookings')
                                .collection('cart')
                                .doc('request')
                                .collection('${user.currentUser!.uid}')
                                .doc('transport')
                                .delete();

                            Navigator.of(context).pop();
                            setState(() {
                              totalpricesub(widget.total, widget.price);
                            });
                          },
                          child: Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('No'),
                        ),
                      ],
                    );
                  });
            }
          }
        },
      ),
    );
  }
}

int totalpricesub(int total, int price) {
  int totalprice;
  totalprice = total - price;

  return totalprice;
}
