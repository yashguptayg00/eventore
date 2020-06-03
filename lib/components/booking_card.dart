import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:flutter/material.dart';
import 'card_attribute.dart';
import 'reusable_card.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingCard extends StatefulWidget {
  final String name;
  final String address;
  final String message;
  final String date;
  final String cEmail;
  final String bookingType;
  final String emEmail;
  final String cancelled;

  BookingCard(
      {Key key,
        @required this.cancelled,
      @required this.emEmail,
      @required this.cEmail,
      @required this.name,
      @required this.address,
      @required this.message,
      @required this.date,
      @required this.bookingType})
      : super(key: key);

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  void deleteData() async {
    //call this mehtod

    var docID;
    await Firestore.instance
        .collection('Bookings')
        .where('em_booked', isEqualTo: widget.emEmail)
        .where('date', isEqualTo: widget.date)
        .getDocuments()
        .then((value) {
      docID = value.documents[0].documentID;
    });

    Firestore.instance.document('Bookings/$docID').updateData({
      'cancelled' : 'yes'
    });

//
//    Firestore.instance.document('Bookings/$docID').delete();
  }

  void launchURL() async {
    String url;
    bool shouldLaunch;
    await Firestore.instance
        .collection('Customer')
        .where('email', isEqualTo: widget.cEmail)
        .getDocuments()
        .then((value) {
      url = value.documents[0].data['phone'];
      print(url);
    });
    String launchingURL = 'tel:$url';
    shouldLaunch = await canLaunch(launchingURL);

    if (shouldLaunch) {
      await launch(launchingURL, forceSafariVC: false, forceWebView: false);
      print('launch successful');
    } else {
      print('could not launch');
    }
  }

  bool showCancelButton = true;
  bool showConfirmButtons = false;
  bool showConfirmationMessage = false;

  String cancelledMessage;
  bool showCancelled = false;
  @override
  void initState() {

    super.initState();
    if(widget.cancelled == 'yes'){
      showCancelled = true;
    }
    if(showCancelled == true){
      showCancelButton = false;
      showConfirmButtons = false;
      showConfirmationMessage = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ReusableCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: width * 0.3,
                    height: height * 0.2,
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookingType == 'book'
                                  ? 'Booking'
                                  : 'Enquiry',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20.0,
                              child: Divider(
                                color: Colors.black54,
                              ),
                            ),
                            CardAttribute(
                              title: 'Booked By : ',
                              value: '${widget.name}',
                            ),
                            CardAttribute(
                              title: 'Address : ',
                              value: '${widget.address}',
                            ),
                            CardAttribute(
                              title: 'Date : ',
                              value: '${widget.date}',
                            ),
                            CardAttribute(
                              title: 'Message : ',
                              value: '${widget.message}',
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                  width: width * 0.3,
                  height: height * 0.2,
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Visibility(
                            visible: showCancelButton,
                            child: GenericButtonSmall(
                              text: 'Contact',
                              onTap: () {
                                launchURL();
                              },
                            ),
                          ),
                          Visibility(
                            visible: showCancelButton,
                            child: GenericButtonSmall(
                              text: 'Cancel',
                              onTap: () {
                                setState(() {
                                  showCancelButton = false;
                                  showConfirmButtons = true;
                                  showConfirmationMessage = true;
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: showConfirmationMessage,
                            child: Text(
                              cancelledMessage == null
                                  ? 'Are you sure?'
                                  : cancelledMessage,
                              style: TextStyle(color: kPinkColor, fontSize: 15),
                            ),
                          ),
                          Visibility(
                            visible: showConfirmButtons,
                            child: GenericButtonSmall(
                              text: 'Yes',
                              onTap: () {
                                setState(() {
                                  cancelledMessage = 'Cancelled';
                                  showConfirmButtons = false;
                                  deleteData();
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: showConfirmButtons,
                            child: GenericButtonSmall(
                              text: 'No',
                              onTap: () {
                                setState(() {
                                  showCancelButton = true;
                                  showConfirmButtons = false;
                                  showConfirmationMessage = false;
                                });
                              },
                            ),
                          ),
                          Visibility(
                            visible: showCancelled,
                            child: Text(
                              'Cancelled',
                              style: TextStyle(
                                color: kPinkColor
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BookingCard2 extends StatefulWidget {
  final String name;
  final String address;
  final String message;
  final String date;
  final String cEmail;
  final String bookingType;
  final String emName;
  final String emEmail;
  final String cancelled;

   BookingCard2(
      {Key key,
        @required this.cancelled,
      @required this.emEmail,
      @required this.emName,
      @required this.cEmail,
      @required this.name,
      @required this.address,
      @required this.message,
      @required this.date,
      @required this.bookingType})
      : super(key: key);

  @override
  _BookingCard2State createState() => _BookingCard2State();
}

class _BookingCard2State extends State<BookingCard2> {
  void launchURL() async {
    String url;
    bool shouldLaunch;

    await Firestore.instance
        .collection('Customer')
        .where('email', isEqualTo: widget.cEmail)
        .getDocuments()
        .then((value) {
      url = value.documents[0].data['phone'];
      print(url);
    });
    String launchingURL = 'tel:$url';
    shouldLaunch = await canLaunch(launchingURL);

    if (shouldLaunch) {
      await launch(launchingURL, forceSafariVC: false, forceWebView: false);
      print('launch successful');
    } else {
      print('could not launch');
    }
  }

  void launchURL2() async {
    String url =
        'mailto:${widget.emEmail}?subject=Regarding your enquiry request&body= ';
    bool shouldLaunch;
    shouldLaunch = await canLaunch(url);
    if (shouldLaunch) {
      await launch(url);
      print('launched');
    } else {
      print('couldnt launch');
    }
  }

  bool showCancelled = false;
@override
  void initState() {
    super.initState();
    if(widget.cancelled == 'yes'){
      showCancelled = true;
    }

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ReusableCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: width * 0.3,
                    height: height * 0.2,
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bookingType == 'book' ? 'Booking' : 'Enquiry',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20.0,
                              child: Divider(
                                color: Colors.black54,
                              ),
                            ),
                            CardAttribute(
                              title: 'EM : ',
                              value: '${widget.emName}',
                            ),
                            CardAttribute(
                              title: 'Customer : ',
                              value: '${widget.name}',
                            ),
                            CardAttribute(
                              title: 'Address : ',
                              value: '${widget.address}',
                            ),
                            CardAttribute(
                              title: 'Date : ',
                              value: '${widget.date}',
                            ),
                            CardAttribute(
                              title: 'Message : ',
                              value: '${widget.message}',
                            ),
                          ],
                        ),
                      ],
                    )),
                Column(
                  children: [
                    Visibility(
                      visible: showCancelled,
                      child: Text(
                        'Cancelled',
                        style: TextStyle(
                            color: kPinkColor
                        ),
                      ),
                    ),
                    GenericButtonSmall(
                      text: 'Contact Customer',
                      onTap: () {
                        launchURL();
                        //TODO launch phone app wiht the given phone number
                      },
                    ),
                    GenericButtonSmall(
                      text: 'Contact EM',
                      onTap: () {
                        launchURL2();
                      },
                    ),

                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
