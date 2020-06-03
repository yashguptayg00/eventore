import 'package:eventia_pro/constants.dart';
import 'package:flutter/material.dart';

//class AboutUs extends StatelessWidget {
//
//  static const id = 'about us';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          'About Us'
//        ),
//      ),
//      body: SafeArea(
//        child: Container(
//          padding: EdgeInsets.all(20),
//          child: Column(
//            children: [
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text(
//                    'Eventia Pro',
//                    style: kBigHeadingStyle,
//                  ),
//                  SizedBox(
//                    height: 20,
//                  ),
//                ],
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: [
//                  Text(
//                      'Eventia pro is India\'s first online platform that help people to find out best Event managers in their locations according to their preferences.',
//                    textAlign: TextAlign.center,
//                  ),
//                  SizedBox(
//                    height: 10,
//                  ),
//                  Text(
//                    'We believe choosing a Event manager is a big and important decision, and hence work towards giving a simple and secure experience for you and your family. Each event managers registered with us goes through a manual screening process before going live on site; we provide superior privacy controls for Free; and also verify all information of the Event managers You can register for Free and search according to your specific criteria on profession,location and much more-.. Regular custom emails and notifications make the process easier and take you closer to your Event management.',
//                    textAlign: TextAlign.center,
//                  )
//                ],
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}

class AboutUs extends StatelessWidget {
  static const id = 'about us';

  @override
  Widget build(BuildContext context) {
    return AboutDialog(
      applicationName: 'Eventia Pro',
      applicationVersion: '1.0.1',

      //todo add app icon here
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Eventia pro is India\'s first online platform that help people to find out best Event managers in their locations according to their preferences.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'We believe choosing a Event manager is a big and important decision, and hence work towards giving a simple and secure experience for you and your family. Each event managers registered with us goes through a manual screening process before going live on site; we provide superior privacy controls for Free; and also verify all information of the Event managers You can register for Free and search according to your specific criteria on profession,location and much more-.. Regular custom emails and notifications make the process easier and take you closer to your Event management.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            )
          ],
        )
      ],
    );
  }
}
