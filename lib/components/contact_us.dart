import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void launchWhatsApp({
  @required String phone,
}) async {
  String url = 'https//:wa.me/$phone';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url}';
  }
}

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Center(
            child: Text(
              'Contact Us',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: GestureDetector(
              onTap: () {
                launchURL('mailto:teameventia@gmail.com?subject=&body=');
              },
              child: Icon(
                Icons.email,
                color: Colors.grey,
              ),
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.chat,
                color: Colors.grey,
              ),
              onTap: () {
                launch('whatsapp://send?phone=919734772983&text=');
              },
            ),
          )
        ],
      ),
    );
  }
}
