import 'package:eventia_pro/components/about_us.dart';
import 'package:eventia_pro/screens/adminLogin.dart';
import 'package:eventia_pro/screens/admin_dashboard.dart';
import 'package:eventia_pro/screens/customer/BookedSuccess.dart';
import 'package:eventia_pro/screens/customer/book_now.dart';
import 'package:eventia_pro/screens/customer/customer_dashboard.dart';
import 'package:eventia_pro/screens/customer/customer_login.dart';
import 'package:eventia_pro/screens/customer/customer_registration.dart';
import 'package:eventia_pro/screens/customer/enquiry_successful.dart';
import 'package:eventia_pro/screens/customer/my_bookings.dart';
import 'package:eventia_pro/screens/customer/results_page.dart';
import 'package:eventia_pro/screens/event_manager/ImageCapture.dart';
import 'package:eventia_pro/screens/event_manager/edit_profile.dart';
import 'package:eventia_pro/screens/event_manager/em_dashboard.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_login.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_register.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_register0.dart';
import 'package:eventia_pro/screens/event_manager/know_more.dart';
import 'package:eventia_pro/screens/splash.dart';
import 'package:eventia_pro/screens/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
//        primaryColor: Color(0xff0d1321),
//        scaffoldBackgroundColor: Color(0xff0d1321),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute: Splash.id,
      routes: {
        Splash.id: (context) => Splash(),
        StartPage.id: (context) => StartPage(),
        CustomerLogin.id: (context) => CustomerLogin(),
        EventManagerLogin.id: (context) => EventManagerLogin(),
        EventManagerRegistration0.id: (context) => EventManagerRegistration0(),
        EventManagerRegistration.id: (context) => EventManagerRegistration(),
        ImageCapture.id: (context) => ImageCapture(),
        EmDashboard.id: (context) => EmDashboard(),

        CustomerRegistration.id: (context) => CustomerRegistration(),
        CustomerDashboard.id: (context) => CustomerDashboard(),
//        Results.id:(context)=>Results(),
        MyBookings.id: (context) => MyBookings(),
//        BookNow.id:(context)=>BookNow(),
        BookedSuccess.id: (context) => BookedSuccess(),
        AboutUs.id: (context) => AboutUs(),
        EditProfile.id: (context) => EditProfile(),
        AdminDashboard.id: (context) => AdminDashboard(),
        AdminLogin.id: (context) => AdminLogin(),
        EnquiredSuccess.id:(context) => EnquiredSuccess(),
//        KnowMore.id:(context)=>KnowMore()
      },
    );
  }
}
