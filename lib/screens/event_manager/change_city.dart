import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/tools/get_city_list.dart';

class ChangeCity extends StatefulWidget {
  final String city;
  final String email;

  ChangeCity({this.city, this.email});

  @override
  _ChangeCityState createState() => _ChangeCityState();
}

class _ChangeCityState extends State<ChangeCity> {
  String city;
  String cityError = '';
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  var docId;
  String newCity = '';
  bool addButtonVis = true;
  String cityString = '';
  List<String> cityList = [];

  @override
  void initState() {
    super.initState();
//    getCityList();
    updateString();
  }

//  void getCityList() async {
//    await _firestore.collection('EventManager').where('user', isEqualTo: widget.email).getDocuments().then((value) {
//      print(value.documents[0].data['City']);
//      cityList = value.documents[0].data['City'];
//    });
//  }

  void changeCity() async {
    await _firestore
        .collection('EventManager')
        .where('user', isEqualTo: widget.email)
        .getDocuments()
        .then((value) {
      docId = value.documents[0].documentID;
      print(value.documents[0].data['City']);
    });
    await _firestore
        .document('EventManager/$docId')
        .updateData({'City': this.cityList}).then((value) {
      print('updated sucesfully');

      setState(() {
        newCity = 'Cities updated to $cityString';
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  void updateString() {
    cityString = '';
    for (var item in cityList) {
      print('the item is $item');
      cityString = cityString + item + ', ';
    }
    print('The string is $cityString');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.0,
                ),
                Hero(
                  tag: 'logo',
                  child: Text(
                    'Cities : ',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
                Visibility(
                  child: Text(cityString),
                ),
                Visibility(
                  visible: !addButtonVis,
                  child: DropdownButton(
                    iconEnabledColor: kPinkColor,
                    focusColor: kPinkColor,
                    dropdownColor: Colors.white,
                    onChanged: (newValue) {
                      setState(() {
                        cityError = '';
                        cityList.add(newValue);
                        updateString();
                        addButtonVis = true;
                      });
                    },
                    items: CityList().getDropDownItems(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          cityList.clear();
                          updateString();
                          print(cityString);
                          print(cityList);
                          addButtonVis = true;
                        });
                        setState(() {});
                      },
                    )
                  ],
                ),
                Text(
                  cityError,
                  style: TextStyle(color: kPinkColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  newCity,
                  style: TextStyle(color: kPinkColor),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GenericButton(
                  onTap: () {
                    changeCity();
                  },
                  text: 'Change City',
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
