import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia_pro/components/booking_card.dart';
import 'package:eventia_pro/components/reusable_card.dart';

class AdminDashboard extends StatefulWidget {
  static const id = 'admin';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email;
  String url;
  List<Widget> cardsList = [];
  var city;
  //
  void getData() async {
    _firestore.collection('Bookings').getDocuments().then((value) {
      int count = value.documents.length;
      print(count);
      setState(() {
        if (count != 0) {
          for (int i = 0; i < count; i++) {
            cardsList.add(
              BookingCard2(
                name: value.documents[i].data['name'],
                address: value.documents[i].data['bookingAddress'],
                message: value.documents[i].data['message'],
                date: value.documents[i].data['date'],
                cEmail: value.documents[i].data['booker'],
                bookingType: value.documents[i].data['bookOrEnquiry'],
                emName: value.documents[i].data['emName'],
                emEmail: value.documents[i].data['em_booked'],
                cancelled:value.documents[i].data['cancelled'],
              ),
            );
          }
        } else {
          cardsList.add(ReusableCard(
            child: Center(
              child: Text('No Bookings yet'),
            ),
          ));
        }

        setState(() {});
      });
    });
  }

  Future<void> getUserEmail() async {
    FirebaseUser user = await _auth.currentUser();
    email = user.email;

    url = 'gs://eventia-pro.appspot.com/images/${email}_profilePic.png';
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
////        leading: Container(),
//        title: Text(
//            'Admin'
//        ),
//
//      ) ,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                      'Assets/evelina-friman-hw_sKmjb0ns-unsplash.jpg'))),
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black),
                      child: Text(
                        '  Admin',
                        style: kBigHeadingStyle.copyWith(
                            color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cardsList,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white54,
        ),
        child: GenericButton(
          text: 'LogOut',
          onTap: () {
            _auth.signOut();
            Navigator.popAndPushNamed(context, StartPage.id);
          },
        ),
      ),
    );
  }
}
