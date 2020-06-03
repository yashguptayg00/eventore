import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/admin_dashboard.dart';
import 'package:eventia_pro/screens/customer/customer_dashboard.dart';
import 'package:eventia_pro/screens/event_manager/em_dashboard.dart';
import 'package:eventia_pro/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class Splash extends StatefulWidget {
  static const id = 'splash';
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  String email;
  var snapshotData;
  String error = '';

  void checkSignedIn() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        FirebaseUser user = await _auth.currentUser();
        if (user != null) {
          if (user.email != 'teameventia@gmail.com') {
            await _firestore
                .collection('EmOrCust')
                .where('email', isEqualTo: user.email)
                .getDocuments()
                .then((value) {
              snapshotData = value.documents[0].data['type'];
            });
            if (snapshotData == 'eventManager') {
              Navigator.popAndPushNamed(context, EmDashboard.id);
            } else {
              Navigator.popAndPushNamed(context, CustomerDashboard.id);
            }
          } else if (user.email == 'teameventia@gmail.com') {
            Navigator.popAndPushNamed(context, AdminDashboard.id);
          }
        } else {
          Navigator.popAndPushNamed(context, StartPage.id);
        }
      }
    } on SocketException catch (_) {
      setState(() {
        error = 'Please check your Internet Connection';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          color: Colors.black,
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () {
          checkSignedIn();
        },
        child: Container(
          color: Colors.black,
          child: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Eventia Pro',
                    style: TextStyle(fontSize: 45.0, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: kPinkColor, fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//  await _firestore.collection('Customer').where('email', isEqualTo: booker).getDocuments().then((value) {
//  url = value.documents[0].data['phone'];
//  print(url);
//  });
//  String launchingURL = 'tel:$url';
