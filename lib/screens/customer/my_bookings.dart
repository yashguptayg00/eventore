import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/em_card.dart';
import 'package:eventia_pro/components/reusable_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBookings extends StatefulWidget {
  static const id = 'my_bookings';

  @override
  _MyBookingsState createState() => _MyBookingsState();
}

class _MyBookingsState extends State<MyBookings> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  List<Widget> cardsList = [];

  String booker;
  bool showRatingButton;
  bool showRatingValue;
  double cRating;

  Future<void> getCards() async {
    FirebaseUser user = await _auth.currentUser();
    booker = user.email;

    try {
      await Firestore.instance
          .collection('Bookings')
          .where('booker', isEqualTo: booker)
          .getDocuments()
          .then((value) {
        if (value.documents.length != 0) {
          for (var doc in value.documents) {
            cRating = doc.data['cRating'];
            if (cRating != null) {
              setState(() {
                showRatingButton = false;
                showRatingValue = true;
              });
            } else {
              setState(() {
                showRatingButton = true;
                showRatingValue = false;
              });
            }

            setState(() {
              cardsList.add(
                EmCardSmall(
                  logo: null,
                  name: doc.data['emName'],
                  emEmail: doc.data['em_booked'],
                  date: doc.data['date'],
                  message: doc.data['message'],
                  booker: doc.data['booker'],
                  showRatingButton: showRatingButton,
                  showRatingValue: showRatingValue,
                  cRating: cRating,
                  cancelled: doc.data['cancelled'],
                ),
              );
            });
          }
          setState(() {});
        } else {
          cardsList.add(ReusableCard(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text('No previous bookings'),
              ),
            ),
          ));
          setState(() {});
        }
      });
    } catch (e) {
      print(e);

      cardsList.add(
        ReusableCard(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text('Error is fetching Booking Details'),
            ),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              SizedBox(
                height: 30.0,
              ),
              Column(
                  children: cardsList == []
                      ? ReusableCard(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                'No previous bookings',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        )
                      : cardsList)
            ],
          ),
        ),
      ),
    );
  }
}
