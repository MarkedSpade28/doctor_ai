import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../home_screen/home_screen.dart';
import '../login_screen/login_screen.dart';


class SplashScreen extends StatefulWidget {
  //route name for our screen
  static String routeName = 'SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //we use future to go from one screen to other via duration time
    Future.delayed(Duration(seconds: 5), (){
      //no return when user is on login screen and press back, it will not return the
      //user to the splash screen


      FirebaseAuth.instance.currentUser == null?
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false) :
           Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    //scaffold color set to primary color in main in our text theme
    return Scaffold(
      backgroundColor: Colors.white,
      //its a row with a column
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Image.asset(
              'assets/images/logo ai.png',
              //25% of height & 50% of width
              height: 35.h,
              width: 60.w,
            ),
          ],
        ),
      ),
    );
  }
}
