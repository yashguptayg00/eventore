import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/customer/BookedSuccess.dart';
import 'package:eventia_pro/screens/customer/enquiry_successful.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eventia_pro/tools/get_event_type.dart';

class BookNow extends StatefulWidget {
  static const id = 'book now';
  final String email;
  final String name;
  final String cEmail;
  BookNow({@required this.email, @required this.name, @required this.cEmail});

  @override
  _BookNowState createState() => _BookNowState();
}

class _BookNowState extends State<BookNow> {
  DateTime dateTime;
  String bookClash = '';
  String bookedOrNot = '';
  DateTime selectedDateTime;
  String displayDate = '';
  String formattedDate;
  String eventType;
  String eventTypeError = '';
  String name;
  String bAddress;
  String pAddress;
  String budget;
  String adhaarLink;
  String message;
  String emName;
  String bookOrEnquiry;
  bool isBookabe = true;

  final _firestrore = Firestore.instance;
  void sendData() async {
    await _firestrore
        .collection('EventManager')
        .where('user', isEqualTo: widget.email)
        .getDocuments()
        .then((value) {
      emName = value.documents[0].data['name'];
    });
    print('name is $name');
    print('email here is ${widget.email}');
    _firestrore.collection('Bookings').add({
      'date': formattedDate,
      'eventType': eventType,
      'name': name,
      'bookingAddress': bAddress,
      'permanentAddress': pAddress,
      'budget': budget,
      'adhaar': adhaarLink,
      'em_booked': widget.email,
      'message': message,
      'booker': widget.cEmail,
      'emName': emName,
      'bookOrEnquiry': bookOrEnquiry,
    });
    if (bookOrEnquiry == 'book') {
      _firestrore.collection('DatesBooked').add(
          {'emName': emName, 'email': widget.email, 'date': formattedDate});
    }
  }

  Future<void> datePicker() async {
    // takes the selected value from calender and converts it into readable string
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

  void dateClashDecider() async {
    var temp;
    var count;
    print('this is formatted date $formattedDate');
    print('email at date picker is ${widget.email}');
    await _firestrore
        .collection('DatesBooked')
        .where('email', isEqualTo: widget.email)
        .where('date', isEqualTo: formattedDate)
        .getDocuments()
        .then((value1) {
      for (var doc in value1.documents) {
        temp = 1;
      }
    });
    if (temp == 1) {
      setState(() {
        bookClash = 'Already booked, but you can still enquire';
        isBookabe = false;
      });
    } else {
      setState(() {
        bookClash = '';
        isBookabe = true;
      });
    }
  }

  void book() {
    if (name != null &&
        bAddress != null &&
        pAddress != null &&
        budget != null &&
        adhaarLink != null) {
      setState(() {
        eventTypeError = '';
        bookOrEnquiry = 'book';
        sendData();
      });
      Navigator.popAndPushNamed(context, BookedSuccess.id);
    } else {
      setState(() {
        eventTypeError = 'Please check your form again';
      });
    }
  }

  void enquire() {
    if (name != null &&
        bAddress != null &&
        pAddress != null &&
        budget != null &&
        adhaarLink != null) {
      setState(() {
        eventTypeError = '';
        bookOrEnquiry = 'enquire';
        sendData();
      });
      Navigator.popAndPushNamed(context, EnquiredSuccess.id);
    } else {
      setState(() {
        eventTypeError = 'Please check your form again';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('the email sent from prev page is ${widget.email}');
    print('booker email is ${widget.cEmail}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book')),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
              Hero(
                tag: 'logo',
                child: Text(
                  'New Booking',
                  style: kBigHeadingStyle,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                'Booking : ${widget.name}',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(
                height: 40.0,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              Text(
                'Type of Event',
                style: TextStyle(color: Colors.black, fontSize: 25.0),
              ),
              SizedBox(
                width: 30.0,
              ),
              DropdownButton(
                value: eventType,
                underline: Text(''),
                iconEnabledColor: kPinkColor,
                focusColor: kPinkColor,
                dropdownColor: Colors.white,
                onChanged: (newValue) {
                  setState(() {
                    eventType = newValue;
                  });
                },
                items: GetEventList().getDropDownItems(),
              ),
              SizedBox(
                height: 30.0,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        formattedDate == null ? 'Select a date' : formattedDate,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await datePicker();
                          dateClashDecider();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.calendar_today,
                          color: kPinkColor,
                        ),
                      )
                    ],
                  ),
                  Text(
                    bookClash,
                    style: TextStyle(color: kPinkColor),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ImprovedTextField(
                    onChanged: (value) {
                      name = value;
                    },
                    text: 'Name',
                  ),
                  ImprovedTextField(
                    onChanged: (value) {
                      bAddress = value;
                    },
                    text: 'Booking Address',
                  ),
                  ImprovedTextField(
                    onChanged: (value) {
                      pAddress = value;
                    },
                    text: 'Present Address',
                  ),
                  ImprovedTextField(
                    onChanged: (value) {
                      budget = value;
                    },
                    text: 'Budget ₹',
                    keyboardType: TextInputType.number,
                  ),
                  ImprovedTextField(
                    onChanged: (value) {
                      message = value;
                    },
                    text: 'Message to Event Manager',
                  ),
                  ImprovedTextField(
                    onChanged: (value) {
                      adhaarLink = value;
                    },
                    text: 'Link to Adhaar Card',
                  )
                ],
              ),
              Text(
                '$eventTypeError',
                style: TextStyle(color: kPinkColor),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Visibility(
              visible: isBookabe,
              child: GenericButton(
                  onTap: () {
                    book();
                  },
                  text: 'Book'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GenericButton(
                onTap: () {
                  enquire();
                },
                text: 'Enquire'),
          ),
        ],
      ),
    );
  }
}
