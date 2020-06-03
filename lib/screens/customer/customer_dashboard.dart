import 'package:eventia_pro/components/about_us.dart';
import 'package:eventia_pro/components/contact_us.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/reusable_card.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/customer/my_bookings.dart';
import 'package:eventia_pro/screens/customer/results_page.dart';
import 'package:eventia_pro/screens/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/tools/get_city_list.dart';
import 'package:eventia_pro/tools/get_event_type.dart';

class CustomerDashboard extends StatefulWidget {
  static const id = 'customer_dashboard';

  @override
  _CustomerDashboardState createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard>
    with SingleTickerProviderStateMixin {
  String city;
  String cityError = '';
  String eventType;
  String eventTypeError = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  AnimationController controller;
  Animation animation, animationColor;

  @override
//  void initState() {
//
//    super.initState();
//
//    controller = AnimationController(vsync: this,
//      duration: Duration(seconds: 1),
//
//    );
//    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
//    controller.forward();
//    animationColor = ColorTween(begin: Colors.blueGrey[900], end: Colors.white).animate(controller);
//    animation.addStatusListener((status) {
//
//    });
//    controller.addListener(() {
//      setState(() {
//
//      });
//      print(animation.value);
//    });
//  }

  @override
//  void dispose() {
//    controller.dispose();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
                onTap: () {
                  Navigator.pushNamed(context, MyBookings.id);
                },
                text: 'My Bookings',
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
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                    'Assets/evelina-friman-hw_sKmjb0ns-unsplash.jpg')),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        'Eventia Pro',
                        style: kBigHeadingStyle.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ReusableCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Type of Events',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 18.0),
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            DropdownButton(
//                            elevation: 10,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                              value: eventType,
                              iconEnabledColor: kPinkColor,
                              focusColor: kPinkColor,
                              dropdownColor: Colors.white,
                              onChanged: (newValue) {
                                setState(() {
                                  eventType = newValue;
                                  eventTypeError = '';
                                });
                              },
                              items: GetEventList().getDropDownItems(),
                            ),
                            Text(
                              eventTypeError,
                              style: TextStyle(color: kPinkColor),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ReusableCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'City',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            DropdownButton(
                              style:
                                  TextStyle(fontSize: 13, color: Colors.black),
                              value: city,
                              iconEnabledColor: kPinkColor,
                              focusColor: kPinkColor,
                              dropdownColor: Colors.white,
                              onChanged: (newValue) {
                                setState(() {
                                  city = newValue;
                                  cityError = '';
                                });
                              },
                              items: CityList().getDropDownItems(),
                            ),
                            Text(
                              cityError,
                              style: TextStyle(color: kPinkColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 60.0,
                  ),
                  GenericButton(
                      onTap: () {
                        if (eventType != null && city != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Results(
                                        eventType: eventType,
                                        city: city,
                                      )));
                          setState(() {});
                        } else if (eventType == null) {
                          setState(() {
                            eventTypeError = 'Please Select an Event Type';
                          });
                        }
                        if (city == null) {
                          setState(() {
                            cityError = 'Please Select a City';
                          });
                        }
                      },
                      text: 'Find Event Managers'),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
