import 'package:eventia_pro/components/generic_button.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/constants.dart';
import 'package:eventia_pro/tools/get_city_list.dart';

class CustomerHamburger extends StatefulWidget {
  @override
  _CustomerHamburgerState createState() => _CustomerHamburgerState();
}

class _CustomerHamburgerState extends State<CustomerHamburger> {
  String city;
  String cityError = '';

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
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.0,
                ),
                Hero(
                  tag: 'logo',
                  child: Text(
                    'City',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
                DropdownButton(
                  value: city,
                  iconEnabledColor: kPinkColor,
                  focusColor: kPinkColor,
                  dropdownColor: Colors.white,
                  onChanged: (newValue) {
                    setState(() {
                      city = newValue;
                      cityError = '';
                    });
                  },
                  items: CityList().getDropDownItems(),
                ),
                Text(
                  cityError,
                  style: TextStyle(color: kPinkColor),
                ),
                SizedBox(
                  height: 20.0,
                ),
                GenericButton(
                  onTap: () {},
                  text: 'Change City',
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
