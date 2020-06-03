import 'package:eventia_pro/components/improved_text_field.dart';
import 'package:eventia_pro/constants.dart';
import 'package:flutter/material.dart';

class EMDegree extends StatelessWidget {
  static const id = 'em_degree';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Any Degrees?',
                style: kBigHeadingStyle,
              ),
              Text(
                'Upload them here',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              ImprovedTextField(text: 'Link')
            ],
          ),
        ),
      ),
    );
  }
}
