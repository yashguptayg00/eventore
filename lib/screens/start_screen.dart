import 'package:eventia_pro/screens/adminLogin.dart';
import 'package:eventia_pro/screens/customer/customer_login.dart';
import 'package:eventia_pro/screens/event_manager/event_manager_login.dart';
import 'package:flutter/material.dart';
import 'package:eventia_pro/components/generic_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class StartPage extends StatefulWidget {
  static const id = 'startPage';

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation, animationColor;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    animationColor = ColorTween(begin: Colors.blueGrey[900], end: Colors.white)
        .animate(controller);
    animation.addStatusListener((status) {});
    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async => false,
      child: SafeArea(
        child: Scaffold(
//        appBar: AppBar(
//          //
//        ),
//
          body: Container(
            padding: EdgeInsets.all(20.0),
//          color: Color(0xff0f0f0f),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 40.0,
                    ),
                    Flexible(
                      child: Hero(
                        tag: 'logo',
                        child: TypewriterAnimatedTextKit(
                          speed: Duration(milliseconds: 300),
                          totalRepeatCount: -1,
                          text: ['Eventia Pro'],
                          textStyle: TextStyle(
                            fontSize: 40.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80.0,
                ),
                GenericButton(
                  text: 'Event Manager',
                  onTap: () {
                    Navigator.popAndPushNamed(context, EventManagerLogin.id);
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                GenericButton(
                  text: 'Customer',
                  onTap: () {
                    Navigator.popAndPushNamed(context, CustomerLogin.id);
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onLongPress: () {
              Navigator.popAndPushNamed(context, AdminLogin.id);
            },
            child: Container(
              height: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
