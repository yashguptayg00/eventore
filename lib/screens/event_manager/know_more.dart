import 'package:flutter/material.dart';

class KnowMore extends StatelessWidget {
  final email;
  KnowMore({this.email});

  static const id = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More Details'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [],
          ),
        ),
      ),
    );
  }
}
