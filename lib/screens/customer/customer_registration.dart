import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/components/logo.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/customer/customer_dashboard.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerRegistration extends StatefulWidget {
  static const id = 'c_regis';

  @override
  _CustomerRegistrationState createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = Firestore.instance;
  String email;
  String password;
  String name;
  String phone;
  bool showSpinner = false;
  String error = '';
  bool shouldLaunch;

  void tnc() async {
    //todo launch website for tnc
    String launchingURL = 'https://techtips150.wixsite.com/mysite-3';
    shouldLaunch = await canLaunch(launchingURL);

    if (shouldLaunch) {
      await launch(launchingURL, forceSafariVC: false, forceWebView: false);
      print('launch successful');
    } else {
      setState(() {
        error = 'Please check your internet connection';
      });
      print('could not launch');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Customer'),
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
                        height: 60.0,
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
                          name = value;
                        },
                        text: 'Name',
                      ),
                      ImprovedTextField(
                        onChanged: (value) {
                          email = value;
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
                      ImprovedTextField(
                        onChanged: (value) {
                          phone = value;
                        },
                        text: 'Phone',
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: kPinkColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Text('By Registering, you agree to the'),
                          GestureDetector(
                            onTap: () {
                              tnc();
                            },
                            child: Text(
                              'Terms and Conditions',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GenericButton(
                          onTap: () async {
                            setState(() {
                              showSpinner = true;
                              error = '';
                            });

                            try {
                              final newUser =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              _fireStore.collection('Customer').add({
                                'email': email,
                                'name': name,
                                'phone': phone
                              });
                              _fireStore
                                  .collection('EmOrCust')
                                  .add({'email': email, 'type': 'customer'});
                              if (newUser != null) {
                                Navigator.popAndPushNamed(
                                    context, CustomerDashboard.id);
                              }

                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              setState(() {
                                error = 'Please check your form again';
                                showSpinner = false;
                              });
                            }
                          },
                          text: 'Register'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Event Manager?'),
                          FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, EventManagerLogin.id);
                            },
                            child: Text(
                              'Login Here',
                              style: TextStyle(color: Colors.lightBlueAccent),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
