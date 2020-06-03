import 'package:eventia_pro/constants.dart';
import 'package:flutter/material.dart';

class ImprovedTextField2 extends StatelessWidget {
  final String text;
  final Function onChanged;
  final bool obscureText;
  final keyboardType;

  ImprovedTextField2(
      {Key key,
      @required this.text,
      this.onChanged,
      this.obscureText,
      this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType == null ? TextInputType.text : keyboardType,
        textAlign: TextAlign.left,
        obscureText: obscureText == null ? false : true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
            borderSide: BorderSide(
              color: kPinkColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(14.0),
            ),
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
