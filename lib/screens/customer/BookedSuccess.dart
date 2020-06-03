import 'package:eventia_pro/components/generic_button.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/screens/customer/customer_dashboard.dart';
import 'package:flutter/material.dart';

class BookedSuccess extends StatelessWidget {
  static const id = 'sucess_booking';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(50),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Booked Successfully! 🎈🎈',
                  style: kBigHeadingStyle,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              GenericButton(
                  onTap: () {
                    Navigator.pushNamed(context, CustomerDashboard.id);
                  },
                  text: 'Done')
            ],
          ),
        ),
      ),
    );
  }
}
