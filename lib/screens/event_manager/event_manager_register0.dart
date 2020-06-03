import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/components/logo.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/customer/customer_login.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class EventManagerRegistration0 extends StatefulWidget {
  static const id = 'em_regis_0';

  @override
  _EventManagerRegistration0State createState() =>
      _EventManagerRegistration0State();
}

class _EventManagerRegistration0State extends State<EventManagerRegistration0> {
  final _auth = FirebaseAuth.instance;
  final _firebase = Firestore.instance;
  String email;
  String password;
  bool showSpinner = false;
  String errors = '';
  bool shouldLaunchtnc;
  bool shouldLaunchCharges;
  void registerButton() async {
    setState(() {
      showSpinner = true;
    });

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _firebase
          .collection('EmOrCust')
          .add({'email': email, 'type': 'eventManager'});
      _firebase.collection('Ratings').add({
        'email': email,
      });
      if (newUser != null) {
        Navigator.popAndPushNamed(context, EventManagerRegistration.id);
      }

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
        errors =
            'Please check Email and Password, Password must be atleast 6 characters long';
      });
    }
  }

  void tnc() async {
    //todo launch website for tnc
    String launchingURL = 'https://techtips150.wixsite.com/mysite-3';
    shouldLaunchtnc = await canLaunch(launchingURL);

    if (shouldLaunchtnc) {
      await launch(launchingURL, forceSafariVC: false, forceWebView: false);
      print('launch successful');
    } else {
      setState(() {
        errors = 'Please check your internet connection';
      });
      print('could not launch');
    }
  }

  void chargesDisplay() async {
    //todo launch website for tnc
    String launchingURL = 'https://techtips150.wixsite.com/eventiacharges';
    shouldLaunchCharges = await canLaunch(launchingURL);

    if (shouldLaunchCharges) {
      await launch(launchingURL, forceSafariVC: false, forceWebView: false);
      print('launch successful');
    } else {
      setState(() {
        errors = 'Please check your internet connection';
      });
      print('could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Event Manager'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Container(
//          color: Colors.white,
              padding: EdgeInsets.all(30.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Logo(
                              radius: 35.0,
                              fontSize: 13.0,
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text('Register', style: kHeadingStyle)
                        ],
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      ImprovedTextField(
                        onChanged: (value) {
                          email = value;
                          email.trim();
                        },
                        text: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      ImprovedTextField(
                        onChanged: (value) {
                          password = value;
                        },
                        text: 'Password',
                        obscureText: true,
                      ),
                      Text(
                        errors,
                        style: TextStyle(color: kPinkColor),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: [
                          Text('By Registering, you agree to the'),
                          GestureDetector(
                            onTap: () {
                              tnc();
                            },
                            child: Text(
                              'Terms and Conditions and',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              chargesDisplay();
                            },
                            child: Text(
                              'Charges and Benifits',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GenericButton(
                          onTap: () async {
                            registerButton();
                          },
                          text: 'Register'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Customer?'),
                          FlatButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                  context, CustomerLogin.id);
                            },
                            child: Text(
                              'Login Here',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
