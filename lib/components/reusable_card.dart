import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Widget child;
  ReusableCard({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.25),
      decoration: BoxDecoration(
          color: Colors.black54, borderRadius: BorderRadius.circular(20)),
      child: Container(
          decoration: BoxDecoration(
            color: Color(0xfffeecec),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: child,
          )),
    );
  }
}
