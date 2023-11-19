
import 'package:doctors_ai/screens/consultation_screen/chat_screen.dart';
import 'package:doctors_ai/screens/consultation_screen/consultation_screen.dart';
import 'package:doctors_ai/screens/consultation_screen/pages/chat_page.dart';
import 'package:doctors_ai/screens/forgotPasswordScreen/forgotPasswordScreen.dart';
import 'package:doctors_ai/screens/home_screen/home_screen.dart';
import 'package:doctors_ai/screens/login_screen/login_screen.dart';
import 'package:doctors_ai/screens/register_screen/register_screen.dart';
import 'package:doctors_ai/screens/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';


Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ChatScreen.routeName: (context) => ChatScreen(),
  // ProvinceListScreen.routeName: (context) => ProvinceListScreen(),
  // PendingApplicationsScreen.routeName: (context) => PendingApplicationsScreen(),
  // RegisteredVotersScreen.routeName: (context) => RegisteredVotersScreen(),
  // ApplicationStatusScreen.routeName: (context) => ApplicationStatusScreen(),
  // NationalVoteScreen.routeName: (context) => NationalVoteScreen(),
  // MyVotesScreen.routeName: (context) => MyVotesScreen(),
  // ProvinceScreen.routeName: (context) => ProvinceScreen(),
  // ResultScreen.routeName: (context) => ResultScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  // ActivityScreen.routeName: (context) => ActivityScreen(),
  // ChatScreen.routeName: (context) => ChatScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  // AddHomeworkScreen.routeName: (context) => AddHomeworkScreen(),
  // ChatHomeScreen.routeName: (context) => ChatHomeScreen(),
  // AddResultsScreen.routeName: (context) => AddResultsScreen(),



};
