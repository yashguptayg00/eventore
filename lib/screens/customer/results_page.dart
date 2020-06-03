import 'package:eventia_pro/components/reusable_card.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'profile_pic_getter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/customer/book_now.dart';
import 'package:eventia_pro/screens/event_manager/know_more.dart';

import 'package:flutter/material.dart';
import 'package:eventia_pro/components/em_card.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Results extends StatefulWidget {
  static const id = 'result';

  Results({@required this.city, @required this.eventType});
  final String city;
  final String eventType;

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
//  Image logo;

  String email;
  String url;
  Image logo;
  List<Widget> cardsList = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  void getUserEmail() async {
    FirebaseUser user = await _auth.currentUser();
    email = user.email;
  }

  @override
  void initState() {
    super.initState();
    getUserEmail();
    getEmData();
  }

  void getEmData() async {
    int count1 = 0;
    int count2 = 0;
    int count3 = 0;

    if (widget.eventType != 'All') {
      await _firestore
          .collection('EventManager')
          .where('City', arrayContains: widget.city)
          .where('eventType', isEqualTo: widget.eventType)
          .getDocuments()
          .then((QuerySnapshot value) {
        count1 = value.documents.length;

        setState(() {
          if (count1 != 0) {
            for (int i = 0; i < count1; i++) {
              cardsList.add(
                EmCard(
                    name: value.documents[i].data['name'],
                    prevEvent: value.documents[i].data['prevEvents'],
                    budget: value.documents[i].data['minBudget'],
                    email: value.documents[i].data['user'],
                    cEmail: email,
                    eventType: value.documents[i].data['eventType'],
                    verified: value.documents[i].data['verified']),
              );
            }
          }
        });
      });

      await _firestore
          .collection('EventManager')
          .where('City', arrayContains: widget.city)
          .where('eventType', isEqualTo: 'All')
          .getDocuments()
          .then((value) {
        count2 = value.documents.length;
        for (var doc in value.documents) {
          cardsList.add(
            EmCard(
              name: doc.data['name'],
              prevEvent: doc.data['prevEvents'],
              budget: doc.data['minBudget'],
              email: doc.data['user'],
              cEmail: email,
              eventType: doc.data['eventType'],
              verified: doc.data['verified'],
            ),
          );
        }
      });
    } else {
      await _firestore
          .collection('EventManager')
          .where('City', arrayContains: widget.city)
          .getDocuments()
          .then((value) {
        count3 = value.documents.length;
        for (var doc in value.documents) {
          cardsList.add(
            EmCard(
                name: doc.data['name'],
                prevEvent: doc.data['prevEvents'],
                budget: doc.data['minBudget'],
                email: doc.data['user'],
                cEmail: email,
                eventType: doc.data['eventType'],
                verified: doc.data['verified']),
          );
        }
      });
    }

    setState(() {});

    print(count1);
    print(count2);
    print(count3);
    if (count1 == 0 && count2 == 0 && count3 == 0) {
      setState(() {
        cardsList.add(ReusableCard(
          child: Center(
            child: Stack(
              children: <Widget>[
                // Stroked text as border.
                Text(
                  'Coming Soon to your city',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = Colors.blue[700],
                  ),
                ),
                // Solid text as fill.
                Text(
                  'Coming Soon to your city',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ));

        setState(() {});
      });
    }
  }

  void downloadImage() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image:
                      AssetImage('Assets/siim-lukka-S8E5a5ZlkNc-unsplash.jpg')),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Hero(
                      tag: 'logo',
                      child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xfffeecec),
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  'Event Managers',
                                  style: kBigHeadingStyle.copyWith(
                                      color: Colors.black, fontSize: 35),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: Text(
                                    'Selected city : ${widget.city}',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 15.0),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: Text(
                                    'Event Type : ${widget.eventType}',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 15.0),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: cardsList,
                    ),
                  ],
                )
              ],
            )),
      ),
      bottomNavigationBar: Container(
        color: Color(0xff182A31),
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: GenericButton(
          onTap: () {
            Navigator.pop(context);
          },
          text: 'Back',
        ),
      ),
    );
  }
}
