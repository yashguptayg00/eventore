import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/about_us.dart';
import 'package:eventia_pro/components/contact_us.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/reusable_card.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/event_manager/change_city.dart';
import 'package:eventia_pro/screens/event_manager/set_busy_date.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/components/booking_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:eventia_pro/screens/start_screen.dart';
import 'edit_profile.dart';

class EmDashboard extends StatefulWidget {
  static const id = 'em_dash';

  @override
  _EmDashboardState createState() => _EmDashboardState();
}

class _EmDashboardState extends State<EmDashboard> {
  final _firestore = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email;
  String url;
  List<Widget> cardsList = [];
  var city;
  //
  void getData() async {
    await getUserEmail();
    _firestore
        .collection('Bookings')
        .where('em_booked', isEqualTo: email)
        .where('bookOrEnquiry', isEqualTo: 'book')
        .getDocuments()
        .then((value) {
      print(email);
      int count = value.documents.length;
      print(count);
      setState(() {
        if (count != 0) {
          for (int i = 0; i < count; i++) {
            cardsList.add(
              BookingCard(
                name: value.documents[i].data['name'],
                address: value.documents[i].data['bookingAddress'],
                message: value.documents[i].data['message'],
                date: value.documents[i].data['date'],
                cEmail: value.documents[i].data['booker'],
                bookingType: value.documents[i].data['bookOrEnquiry'],
                emEmail: value.documents[i].data['em_booked'],
                cancelled: value.documents[i].data['cancelled'],
              ),
            );
          }
        } else {
          cardsList.add(ReusableCard(
            child: Center(
              child: Text('No Current Bookings'),
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
//    getUserEmail();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        leading: Container(),
        title: Text('Eventia Pro'),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Center(
                child: Text(
                  'Eventia Pro',
                  style: TextStyle(fontSize: 30.0, color: kPinkColor),
                ),
              ),
              SizedBox(
                height: 30.0,
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GenericButtonSmall(
                onTap: () async {
                  await _firestore
                      .collection('EventManager')
                      .where('user', isEqualTo: email)
                      .getDocuments()
                      .then((value) {
                    city = value.documents[0].data['city'];
                  });
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ChangeCity(
                          city: city,
                          email: email,
                        ),
                      ),
                    ),
                  );
                },
                text: 'Change City',
              ),
              GenericButtonSmall(
                text: 'Set Busy Dates',
                onTap: () {
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SetBusyDate(),
                      ),
                    ),
                  );
                },
              ), //change city button
              GenericButtonSmall(
                text: 'Edit Profile',
                onTap: () {
                  Navigator.popAndPushNamed(context, EditProfile.id);
                },
              ),

              GenericButtonSmall(
                onTap: () async {
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, StartPage.id);
                },
                text: 'Sign-Out',
              ),
              GenericButtonSmall(
                text: 'About Us',
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationName: 'Eventia Pro',
                      applicationVersion: '1.0.2',
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Eventia pro is India\'s first online platform that help people to find out best Event managers in their locations according to their preferences.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'We believe choosing a Event manager is a big and important decision, and hence work towards giving a simple and secure experience for you and your family. Each event managers registered with us goes through a manual screening process before going live on site; we provide superior privacy controls for Free; and also verify all information of the Event managers You can register for Free and search according to your specific criteria on profession,location and much more-.. Regular custom emails and notifications make the process easier and take you closer to your Event management.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        )
                      ]);
                },
              ),
              ContactUs()
            ],
          ),
        ),
      ),
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
                        'My Bookings',
                        style: kBigHeadingStyle.copyWith(color: Colors.white),
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
    );
  }
}
