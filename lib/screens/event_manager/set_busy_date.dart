import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SetBusyDate extends StatefulWidget {
  @override
  _SetBusyDateState createState() => _SetBusyDateState();
}

class _SetBusyDateState extends State<SetBusyDate> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  FirebaseUser loggedInUser;
  String formattedDate;
  String message = '';

  Future<void> getCurrentUser() async {
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

  void shoeDatePicker() async {
    DateTime dateTime;
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2002),
      lastDate: DateTime(2400),
    ).then((value) {
      setState(() {
        dateTime = value;
      });
      formattedDate = '${DateFormat.yMMMMEEEEd().format(dateTime)}';
    });
  }

  void addBusyDate() async {
    Firestore.instance
        .collection('DatesBooked')
        .add({'email': loggedInUser.email, 'date': formattedDate});
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
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ListTile(
                title: Text(
                    formattedDate == null ? 'Select a date' : formattedDate),
                trailing: GestureDetector(
                  onTap: () {
                    shoeDatePicker();
                  },
                  child: Icon(
                    Icons.calendar_today,
                    color: kPinkColor,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                message,
                style: TextStyle(color: Colors.blue),
              ),
              SizedBox(
                height: 10,
              ),
              GenericButton(
                text: 'Add Busy Date',
                onTap: () async {
                  await getCurrentUser();
                  addBusyDate();
                  setState(() {
                    message = 'The date $formattedDate added to busy list';
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
