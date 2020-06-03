import 'package:eventia_pro/constants.dart';
import 'package:flutter/material.dart';

class ImprovedTextField extends StatelessWidget {
  final String text;
  final Function onChanged;
  final bool obscureText;
  final keyboardType;

  ImprovedTextField(
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

class ImprovedTextField2 extends StatefulWidget {
  final String text;
  final Function onChanged;
  final bool obscureText;
  final keyboardType;
  final TextEditingController initial;

  ImprovedTextField2(
      {Key key,
      @required this.text,
      this.onChanged,
      this.obscureText,
      this.keyboardType,
      this.initial})
      : super(key: key);

  @override
  _ImprovedTextField2State createState() => _ImprovedTextField2State();
}

class _ImprovedTextField2State extends State<ImprovedTextField2> {
  @override
  void initState() {
    super.initState();
    print('uin sent to tf is ${widget.initial}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: widget.initial,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType == null
            ? TextInputType.text
            : widget.keyboardType,
        textAlign: TextAlign.left,
        obscureText: widget.obscureText == null ? false : true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: widget.text,
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
