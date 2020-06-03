import 'package:flutter/material.dart';

class GetEventList{
  List<DropdownMenuItem<String>> getDropDownItems (){
    List<DropdownMenuItem<String>> eventDropdownMenuItems = [];
    for (String city in eventList){
      eventDropdownMenuItems.add(
          DropdownMenuItem(
            child: Text(
                city
            ),
            value: city,
          )
      );
    }

    return eventDropdownMenuItems;
  }
}

const List<String> eventList = [
  'Wedding',
  'Wedding Receptions',
  'Birthday Parties',
  'Festival Gatherings',
  'Ensuring team building exercises',
  'Business Dinners',
  'Conferences'
  'Networking Events',
  'Seminars',
  'Product launches',
  'Meetings',
  'Charity/Fundraising',
  'All'
];