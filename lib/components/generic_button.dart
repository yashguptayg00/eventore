import 'package:flutter/material.dart';
import 'package:eventia_pro/constants.dart';

class GenericButton extends StatelessWidget {
  final String text;
  final Function onTap;
  GenericButton({Key key, @required this.text, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: kPinkColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.2,
                spreadRadius: 0.0,
              )
            ]),
        padding: EdgeInsets.symmetric(vertical: 21.0, horizontal: 19.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
//            color: Color(0xff0f0f0f),
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

class GenericButtonSmall extends StatelessWidget {
  final String text;
  final Function onTap;
  GenericButtonSmall({@required this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: kPinkColor,
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.grey,
//                  blurRadius: 2,
//                  spreadRadius: 0.0,
//                )
//              ]
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
//            color: Color(0xff0f0f0f),
              fontWeight: FontWeight.w500,
              fontSize: 13.0,
            ),
          ),
        ),
      ),
    );
  }
}
