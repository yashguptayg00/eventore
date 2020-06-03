import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/event_manager/ImageCapture.dart';
import 'package:eventia_pro/tools/get_event_type.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eventia_pro/tools/get_city_list.dart';

class EventManagerRegistration extends StatefulWidget {
  static const id = 'event_manager_registration2';

  @override
  _EventManagerRegistrationState createState() =>
      _EventManagerRegistrationState();
}

class _EventManagerRegistrationState extends State<EventManagerRegistration> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  FirebaseUser loggedInUser;
  String name = '-';
  String address = '-';
  String website = '-';
  String minBudget = '';
  String prevEvents = '';
  String city;
  String phone;
  String degree = '-';
  String eventType;
  String eventTypeError = '';
  String cityError = '';
  String degreeLink;
  String prevPicsLink;
  DocumentReference documentReference;
  List<String> cityTest = []; //todo finally send this to db
  List<Widget> cityAddButtonList = [];
  String listOfCities = '';
  String error = '';

//  void addCityButton() {
//    String value;
//    cityAddButtonList.add(
//
//
//    ) ;
//  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
//    addCityButton();
  }

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
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDocRef() async {
    if (eventType != null &&
        city != null &&
        name != null &&
        address != null &&
        minBudget != null &&
        prevEvents != null) {
//      await _fireStore
//          .collection('TypesOfEvents')
//          .add({'eventType': eventType});
      documentReference = _fireStore.collection('EventManager').document();
    }
  }

  void registerEM() async {
    try {
      if (eventType != null &&
          city != null &&
          name != null &&
          address != null &&
          minBudget != null &&
          prevEvents != null) {
        if (loggedInUser != null) {
          await documentReference.setData({
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
            'id': documentReference.documentID,
            'City': cityTest
          });
          setState(() {
            eventTypeError = '';
            cityError = '';
          });
          Navigator.popAndPushNamed(context, ImageCapture.id);
        } else if (eventType == null) {
          setState(() {
            eventTypeError = 'Please select an Event Type';
          });
        }
        if (city == null) {
          cityError = 'Please select a City';
        }
      } else {
        setState(() {
          error = 'Please check your Form again';
        });
      }
    } catch (e) {
      print(e);
    }
  }
//  void convertToString(){
//    for (var value in cityTest){
//      setState(() {
//        listOfCities.
//      });
//    }
//  }

  bool addButtonVis = true;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                      child: Text('Register',
                          style: TextStyle(
                            color: kPinkColor,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    ImprovedTextField(
                      onChanged: (value) {
                        name = value;
                      },
                      text: 'Name',
                    ),
                    ImprovedTextField(
                      onChanged: (value) {
                        address = value;
                      },
                      text: 'Address',
                    ),
                    ImprovedTextField(
                      onChanged: (value) {
                        phone = value;
                      },
                      text: 'Phone (Optional)',
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
                                    city = newValue;
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

                        //todo add a 'add' button that displays another cdropdown list where user can select another city
                        //todo the data in array listTest gets sent to em doc in the form of array, later query that array to get search results
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
                    ImprovedTextField(
                      onChanged: (value) {
                        website = value;
                      },
                      text: 'Website / Social Media Link',
                    ),
                    ImprovedTextField(
                      onChanged: (value) {
                        minBudget = value;
                      },
                      text: 'Min Budget',
                      keyboardType: TextInputType.number,
                    ),
                    ImprovedTextField(
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
                    Text(
                      'Please provide a link for these',
                      style: TextStyle(color: Colors.black, fontSize: 25.0),
                    ),
                    Text(
                      '(If Relevant)',
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ImprovedTextField(
                      onChanged: (value) {
                        degreeLink = value;
                      },
                      text: 'Link to Degrees',
                    ),
                    ImprovedTextField(
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
                              await getDocRef();
                              registerEM();
                            },
                            text: 'Next'),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already a user?'),
                            FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, EventManagerLogin.id);
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
