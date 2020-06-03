import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:flutter/material.dart';

class Rate extends StatefulWidget {
  @override
  _RateState createState() => _RateState();
}

class _RateState extends State<Rate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
          child: Column(
            children: [
              Text(
                'Rate Event Manager',
                style: TextStyle(
                    color: kPinkColor,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600),
              ),
              TextField(
                onChanged: (value) {
                  //todo send value back to my bookings page
                },
                autofocus: true,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 22.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                      child: GenericButton(
                    onTap: () {},
                    text: 'Rate',
                  )),
                ],
              ),
              SizedBox(
                height: 30.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
