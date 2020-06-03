import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double radius;
  double fontSize = 18.0;

  Logo({@required this.radius, this.fontSize});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      child: Container(
        child: Text(
          'EVENTIA',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
