import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/admin_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  static const id = 'adminlign';

  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  String email;

  String password;

  void authwnticationAdmin() async {
    if (email.trim() == 'teameventia@gmail.com') {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Navigator.popAndPushNamed(context, AdminDashboard.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  'Admin Login',
                  style: kBigHeadingStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                ImprovedTextField(
                  text: 'Email',
                  onChanged: (value) {
                    email = value;
                  },
                ),
                ImprovedTextField(
                  text: 'Password',
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                GenericButton(
                  text: 'Login',
                  onTap: () {
                    authwnticationAdmin();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
