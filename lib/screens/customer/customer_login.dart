import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/screens/customer/customer_dashboard.dart';
import 'package:eventia_pro/screens/customer/customer_registration.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/components/logo.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:eventia_pro/screens/event_manager/em_dashboard.dart';

class CustomerLogin extends StatefulWidget {
  static const id = 'customer_login';

  @override
  _CustomerLoginState createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String errors = '';
  String resetPassword = '';
  final _firestore = Firestore.instance;
  var snapshotData;

  void getLoginStatus() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      Navigator.pushNamed(context, CustomerDashboard.id);
    }
  }

  @override
  void initState() {
    super.initState();
    getLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Customer Login'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            color: Colors.white,
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
                        Text('Login', style: kHeadingStyle)
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
                      height: 10,
                    ),
                    Text(
                      resetPassword,
                      style: TextStyle(color: kPinkColor),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GenericButton(
                        onTap: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final loggedInUser =
                                await _auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            if (loggedInUser != null) {
                              await _firestore
                                  .collection('EmOrCust')
                                  .where('email', isEqualTo: email)
                                  .getDocuments()
                                  .then((value) {
                                snapshotData = value.documents[0].data['type'];
                              });
                              if (snapshotData == 'eventManager') {
                                Navigator.popAndPushNamed(
                                    context, EmDashboard.id);
                              } else {
                                Navigator.popAndPushNamed(
                                    context, CustomerDashboard.id);
                              }
//                              Navigator.pushNamed(context, EmDashboard.id);

                              setState(() {
                                showSpinner = false;
                                errors = '';
                              });
                            }
                          } catch (E) {
                            setState(() {
                              showSpinner = false;
                              errors = 'Invalid Username or Password';
                              print(E);
                            });
                          }
                        },
                        text: 'Login'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Forgot Password?'),
                        FlatButton(
                          onPressed: () {
                            if (email != null) {
                              setState(() {
                                _auth.sendPasswordResetEmail(email: email);
                                resetPassword =
                                    'Password Reset link sent to your email';
                              });
                            }
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('New User?'),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, CustomerRegistration.id);
                          },
                          child: Text(
                            'Register Here',
                            style: TextStyle(color: Colors.lightBlueAccent),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Event Manager?'),
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, EventManagerLogin.id);
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
    );
  }
}
