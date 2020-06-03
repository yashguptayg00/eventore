import 'package:flutter/material.dart';
import 'package:eventia_pro/constants.dart';

class CardAttribute extends StatelessWidget {
  final String title;
  final String value;

  const CardAttribute({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: RichText(
        text: TextSpan(
            text: '$title',
            style: kCardAttribute,
            children: <TextSpan>[
              TextSpan(text: '$value', style: TextStyle(color: kPinkColor))
            ]),
      ),
    );
  }
}
