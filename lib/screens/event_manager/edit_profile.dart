import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/event_manager/ImageCapture.dart';
import 'package:eventia_pro/screens/event_manager/em_dashboard.dart';
import 'package:eventia_pro/tools/get_event_type.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia_pro/tools/get_city_list.dart';

class EditProfile extends StatefulWidget {
  static const id = 'edit profile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  FirebaseUser loggedInUser;
  String name = '-';
  String address = '-';
  String website = '-';
  String minBudget = '';
  String prevEvents = '';
  String phone;
  String eventType;
  String eventTypeError = '';
  String cityError = '';
  String degreeLink;
  String prevPicsLink;
  var documentReference;
  List<String> cityTest = []; //todo finally send this to db
  List<Widget> cityAddButtonList = [];
  String listOfCities = '';
  String error = '';
  bool addButtonVis = true;

  String oName;
  String oAddress;
  String oWebsite;
  String oMinBudget;
  String oPrevEvents;
  String oPhone;
  String oDegree;
  String oPrevPics;

  TextEditingController controller0;
  TextEditingController controller1;
  TextEditingController controller2;
  TextEditingController controller3;
  TextEditingController controller4;
  TextEditingController controller5;
  TextEditingController controller6;
  TextEditingController controller7;

  void updateString() {
    listOfCities = '';
    for (var item in cityTest) {
      listOfCities = listOfCities + item + ', ';
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
        await fetchData();
        setState(() {
          controller0 = TextEditingController(text: oName);
          name = oName;
          controller1 = TextEditingController(text: oAddress);
          address = oAddress;
          controller2 = TextEditingController(text: oPhone);
          phone = oPhone;
          controller3 = TextEditingController(text: oWebsite);
          website = oWebsite;
          controller4 = TextEditingController(text: oMinBudget);
          minBudget = oMinBudget;
          controller5 = TextEditingController(text: oPrevEvents);
          prevEvents = oPrevEvents;
          controller6 = TextEditingController(text: oDegree);
          degreeLink = oDegree;
          controller7 = TextEditingController(text: oPrevPics);
          prevPicsLink = oPrevEvents;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchData() async {
    await _fireStore
        .collection('EventManager')
        .where('user', isEqualTo: loggedInUser.email)
        .getDocuments()
        .then((value) {
      var doc = value.documents[0];
      oName = doc.data['name'];
      oAddress = doc.data['address'];
      oWebsite = doc.data['website'];
      oMinBudget = doc.data['minBudget'];
      oPrevEvents = doc.data['prevEvents'];
      oPrevPics = doc.data['prevPicsLink'];
      oDegree = doc.data['degreeLink'];
      oPhone = doc.data['phone'];
      print(oPhone);
    });
  }

  void updateData() async {
    if (cityList.length != 0 && eventType != null) {
      await _fireStore
          .collection('EventManager')
          .where('user', isEqualTo: loggedInUser.email)
          .getDocuments()
          .then((value) {
        documentReference = value.documents[0].documentID;
      });
      await _fireStore.document('EventManager/$documentReference').updateData({
        'name': name,
        'address': address,
        'website': website,
        'minBudget': minBudget,
        'prevEvents': prevEvents,
        'prevPicsLink': prevPicsLink,
        'degreeLink': degreeLink,
        'phone': phone,
        'eventType': eventType,
        'user': loggedInUser.email,
        'id': documentReference,
        'City': cityTest
      });
      Navigator.popAndPushNamed(context, EmDashboard.id);
    } else {
      setState(() {
        cityError = 'List of Cities cannot be empty';
        eventTypeError = 'Event Type cannot be empty';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all((20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'logo',
                    child: Text('Update Profile',
                        style: TextStyle(
                          color: kPinkColor,
                          fontSize: 40.0,
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  ImprovedTextField2(
                    initial: controller0,
                    onChanged: (value) {
                      name = value;
                    },
                    text: 'Name',
                  ),

                  ImprovedTextField2(
                    initial: controller1,
                    onChanged: (value) {
                      address = value;
                    },
                    text: 'Address',
                  ),
                  ImprovedTextField2(
                    initial: controller2,
                    onChanged: (value) {
                      phone = value;
                    },
                    text: 'Phone',
                    keyboardType: TextInputType.number,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cities : ',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      Text(listOfCities),
                      Column(
                        children: [
                          Visibility(
                            visible: !addButtonVis,
                            child: DropdownButton(
                              iconEnabledColor: kPinkColor,
                              focusColor: kPinkColor,
                              dropdownColor: Colors.white,
                              onChanged: (newValue) {
                                setState(() {
                                  cityTest.add(newValue);
                                  print(cityTest);
                                  cityError = '';
                                  addButtonVis = true;
                                  updateString();
                                });
                              },
                              items: CityList().getDropDownItems(),
                            ),
                          ),
                          Row(
                            children: [
                              Visibility(
                                visible: addButtonVis,
                                child: GenericButtonSmall(
                                  onTap: () {
                                    setState(() {
                                      addButtonVis = false;
                                    });
                                  },
                                  text: 'Add',
                                ),
                              ),
                              Visibility(
                                visible: !addButtonVis,
                                child: GenericButtonSmall(
                                  text: 'Cancel',
                                  onTap: () {
                                    setState(() {
                                      addButtonVis = true;
                                    });
                                  },
                                ),
                              ),
                              GenericButtonSmall(
                                text: 'Clear',
                                onTap: () {
                                  setState(() {
                                    cityTest.clear();
                                    updateString();
                                    print(listOfCities);
                                    print(cityTest);
                                    addButtonVis = true;
                                  });
                                  setState(() {});
                                },
                              )
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: cityAddButtonList,
                      ),
                      Text(
                        cityError,
                        style: TextStyle(color: kPinkColor),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),

                  ImprovedTextField2(
                    initial: controller3,
                    onChanged: (value) {
                      website = value;
                    },
                    text: 'Website / Social Media Link',
                  ),

                  ImprovedTextField2(
                    initial: controller4,
                    onChanged: (value) {
                      minBudget = value;
                    },
                    text: 'Min Budget',
                    keyboardType: TextInputType.number,
                  ),

                  ImprovedTextField2(
                    initial: controller5,
                    onChanged: (value) {
                      prevEvents = value;
                    },
                    text: 'No. of Previous Events',
                    keyboardType: TextInputType.number,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Type of Events',
                        style: TextStyle(color: Colors.black, fontSize: 25.0),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      DropdownButton(
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
                  SizedBox(
                    height: 30.0,
                  ),
//                  Text(
//                    'Please provide a link for these',
//                    style: TextStyle(color: Colors.black, fontSize: 25.0),
//                  ),
//                  Text(
//                    '(If Relevant)',
//                    style: TextStyle(color: Colors.black, fontSize: 20.0),
//                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ImprovedTextField2(
                    initial: controller6,
                    onChanged: (value) {
                      degreeLink = value;
                    },
                    text: 'Link to Degrees',
                  ),

                  ImprovedTextField2(
                    initial: controller7,
                    onChanged: (value) {
                      prevPicsLink = value;
                    },
                    text: 'Link to Photos of Prev. Events',
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        error,
                        style: TextStyle(color: kPinkColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GenericButton(
                          onTap: () async {
                            updateData();
                          },
                          text: 'Update'),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ));
  }
}
