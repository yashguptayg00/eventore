import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/card_attribute.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'reusable_card.dart';
import 'package:eventia_pro/screens/customer/book_now.dart';
import 'package:eventia_pro/screens/event_manager/know_more.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:eventia_pro/screens/customer/rate.dart';

final _firestore = Firestore.instance;

class EmCard extends StatefulWidget {
  final String prevEvent;
  final String budget;

  final String name;

  final Function onBookNow;
  final Function onEnquiry;
  final Function onKnowMore;
  final String email;
  final String cEmail;
  final String eventType;
  final String verified;

  EmCard(
      {Key key,
      @required this.verified,
      @required this.eventType,
      @required this.cEmail,
      @required this.email,
      @required this.budget,
      @required this.prevEvent,
      @required this.name,
      this.onBookNow,
      this.onEnquiry,
      this.onKnowMore})
      : super(key: key);

  @override
  _EmCardState createState() => _EmCardState();
}

class _EmCardState extends State<EmCard> {
  String url;
  String _downloadURL;
  bool shouldLaunch;
  Image logo;
  String emEmail;

  void downloadImage() async {
    try {
      String path = 'images/${widget.email}profilePic.png';

      final FirebaseAuth _auth = FirebaseAuth.instance;
      final Firestore _firestore = Firestore.instance;
      StorageReference reference =
          await FirebaseStorage.instance.ref().child(path);

      String downloadurl = await reference.getDownloadURL();
      setState(() {
        _downloadURL = downloadurl;
        logo = Image.network(_downloadURL);
      });
    } catch (e) {
      logo = Image(
        image: AssetImage('Assets/ben-sweet-2LowviVHZ-E-unsplash.jpg'),
      );
    }
  }

  void launchUrl() async {
    await _firestore
        .collection('EventManager')
        .where('user', isEqualTo: widget.email)
        .getDocuments()
        .then((value) {
      url = value.documents[0].data['website'];
      print(url);
    });
    String launchingURL = 'http://$url';
    shouldLaunch = await canLaunch(launchingURL);

    if (shouldLaunch) {
      await launch(launchingURL, forceSafariVC: false, forceWebView: false);
      print('launch successful');
    } else {
      print('could not launch');
    }
  }

  @override
  void initState() {
    print('email in em_card now ${widget.email}');
    super.initState();
    downloadImage();
    emEmail = widget.email;
    calculateRatings();
  }

  double finalRating;
  String displayRating;
  double count = 0;
  double sum = 0;

  void calculateRatings() async {
    await _firestore
        .collection('Bookings')
        .where('em_booked', isEqualTo: emEmail)
        .where('bookOrEnquiry', isEqualTo: 'book')
        .where('rated', isEqualTo: 'yes')
        .getDocuments()
        .then((value) {
      for (var doc in value.documents) {
        count++;
        sum = sum + doc.data['cRating'];
        print('sum is $sum');
        print('count is $count');
      }
    });

    finalRating = sum / count;
    print('final rating is $finalRating');
    if(finalRating >= 0.0){
      displayRating = finalRating.toStringAsFixed(1);
      print ('display rating is $displayRating');
      sendRating(finalRating);
    }
  }

  void sendRating(double finalRating) async {
    var docID;
    await _firestore
        .collection('Ratings')
        .where('email', isEqualTo: emEmail)
        .getDocuments()
        .then((value) {
      docID = value.documents[0].documentID;
    });
    await _firestore
        .document('Ratings/$docID')
        .updateData({'rating': finalRating});
  }
  //todo implement verified status

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        ReusableCard(
            child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: widget.verified == 'yes' ? true : false,
                child: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0)),
                      height: 0.2 * height,
                      width: 0.3 * size,
                      child: logo == null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Text(
                                  '...',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                          : logo,
                    ),
                    SizedBox(
                      width: 0.03 * size,
                    ),
                    Container(
                      width: 0.4 * size,
                      height: 0.2 * height,
                      child: ListView(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(children: [
                                Text(
                                  '${widget.name}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.0),
                                ),
                              ]),
                              SizedBox(
                                height: 20.0,
                                child: Divider(
                                  color: Colors.black54,
                                ),
                              ),
                              CardAttribute(
                                title: 'No. of Previous Events : ',
                                value: '${widget.prevEvent}',
                              ),
                              CardAttribute(
                                title: 'Budget : ',
                                value: '₹${widget.budget}',
                              ),
                              CardAttribute(
                                title: '',
                                value: displayRating == null? '' : '$displayRating ⭐'
                              ),
                              CardAttribute(
                                title: 'Event Type : ',
                                value: widget.eventType,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GenericButtonSmall(
                      onTap: () {
                        print('the email sent to booknow is $emEmail');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookNow(
                                      email: emEmail,
                                      name: widget.name,
                                      cEmail: widget.cEmail,
                                    )));
                      },
                      text: 'Book now / Enquiry',
                    ),
                    GenericButtonSmall(
                      onTap: () async {
                        launchUrl();
//                        Navigator.push(context, MaterialPageRoute(
//                          builder: (context) => KnowMore(email: email,)
                        //));

                        try {} catch (e) {}
                      },
                      text: 'More Details',
                    )
                  ],
                )
              ],
            ),
          ],
        )),
        SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}

class EmCardSmall extends StatefulWidget {
  final String emEmail;
  final String name;
  final Image logo;
  final String date;
  final String message;
  final String booker;
  final bool showRatingButton;
  bool showRatingValue;
  final double cRating;
  final String cancelled;

  EmCardSmall(
      {Key key,
        @required this.cancelled,
      @required this.emEmail,
      @required this.showRatingButton,
      @required this.cRating,
      @required this.showRatingValue,
      @required this.booker,
      @required this.name,
      @required this.logo,
      this.date,
      this.message})
      : super(key: key);

  @override
  _EmCardSmallState createState() => _EmCardSmallState();
}

class _EmCardSmallState extends State<EmCardSmall> {
  void launchUrl() async {
    String url;
    bool shouldLaunch;
    await _firestore
        .collection('EventManager')
        .where('user', isEqualTo: widget.emEmail)
        .getDocuments()
        .then((value) {
      url = value.documents[0].data['website'];
      print(url);
    });
    String launchingURL = 'http://$url';
    shouldLaunch = await canLaunch(launchingURL);

    if (shouldLaunch) {
      await launch(launchingURL, forceSafariVC: false, forceWebView: false);
      print('launch successful');
    } else {
      print('could not launch');
    }
  }

  bool showRatingButton2;
  bool showNewRatingValue = false;
  bool rateButtonVisibility = false;
  bool showCancelled = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init state called');
    showRatingButton2 = widget.showRatingButton;
    if(widget.cancelled == 'yes'){
      showCancelled = true;
    }
  }

  double newRating;
  var docID;
  var docID2;
  void sendRating() async {
    await _firestore
        .collection('Bookings')
        .where('em_booked', isEqualTo: widget.emEmail)
        .where('bookOrEnquiry', isEqualTo: 'book')
        .where('date', isEqualTo: widget.date)
        .getDocuments()
        .then((value) {
      docID = value.documents[0].documentID;
    });
    await _firestore.document('Bookings/$docID').updateData({
      'cRating': newRating,
      'rated': 'yes',
    });
    await _firestore
        .collection('Ratings')
        .where('email', isEqualTo: widget.emEmail)
        .getDocuments()
        .then((value) {
      docID2 = value.documents[0].documentID;
    });

    await _firestore
        .document('Ratings/$docID2')
        .updateData({'rating': newRating});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: ReusableCard(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 20.0,
          ),
          Text(
            '${widget.name}',
            style: TextStyle(color: Colors.black, fontSize: 20.0),
          ),
          CardAttribute(
            title: 'Date : ',
            value: '${widget.date}',
          ),
          CardAttribute(
            title: 'Message Sent : ',
            value: '${widget.message}',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GenericButtonSmall(
                onTap: () {
                  launchUrl();
                },
                text: 'More Details',
              ),
              Visibility(
                visible: showRatingButton2,
                child: GenericButtonSmall(
                  onTap: () {
                    setState(() {
                      showRatingButton2 = false;
                      showNewRatingValue = !showNewRatingValue;
                      rateButtonVisibility = true;
//                          showModalBottomSheet(
//                            context: context,
//                            builder: (context) => SingleChildScrollView(
//                              child: Container(
//                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//                                child: Rate(),
//                              ),
//                            ),
//                          );
//                          setState(() {
//
//                          }); //code to show bottom sheet for rating
                    });

                    setState(() {
                      widget.showRatingValue = true;
                    });
                  },
                  text: 'Rate',
                ),
              ),
              Visibility(
                visible: widget.showRatingValue,
                child: Text(
                  widget.cRating == null
                      ? 'My Rating : $newRating ⭐'
                      : 'My Rating : ${widget.cRating} ⭐',
                  style: TextStyle(color: kPinkColor),
                ),
              ),
//                  Visibility(
//                    visible: showRatingValue,
//                    child: TextField(
//                      textAlign: TextAlign.center,
//                      onChanged: (value){
//                        newRating = value.trim();
//                        print (newRating);
////                        sendRating();
//                      },
//                    )
//                  )
            ],
          ),


          Visibility(
            visible: showNewRatingValue,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kPinkColor
              ),
              child: RatingBar(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.all(8),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value){
                  setState(() {
                    newRating = value;
                    print(newRating);
                  });
                },
              ),
            )
          ),
          SizedBox(
            height: 5.0,
          ),
          Visibility(
            visible: rateButtonVisibility,
            child: GenericButton(
              onTap: () {
                sendRating();
                setState(() {
                  rateButtonVisibility = false;
                  showNewRatingValue = false;
                });
              },
              text: 'Rate',
            ),
          ),
          Visibility(
            visible:showCancelled ,
            child: Text(
              'Cancelled',
              style: TextStyle(
                color: kPinkColor
              ),
            ),
          )
        ],
      )),
    );
  }
}
