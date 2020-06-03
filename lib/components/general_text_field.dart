import 'package:flutter/material.dart';

class GeneralTextField extends StatelessWidget {
  GeneralTextField(
      {@required this.onChanged,
      this.hintText,
      this.obscureText,
      this.textInputType});
  final bool obscureText;
  final TextInputType textInputType;
  final Function onChanged;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType == null ? TextInputType.text : textInputType,
      obscureText: obscureText == null ? false : obscureText,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.grey[800],
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
