



import 'package:doctors_ai/widgets/AppDialog.dart';
import 'package:doctors_ai/widgets/ErrorMessageDialog.dart';
import 'package:doctors_ai/widgets/VerifyEmailDialog.dart';
import 'package:doctors_ai/widgets/acceptDialog.dart';
import 'package:doctors_ai/widgets/changePassword.dart';
import 'package:doctors_ai/widgets/deleteDialog.dart';
import 'package:doctors_ai/widgets/forgotPasswordDialog.dart';
import 'package:doctors_ai/widgets/resetPasswordConfirmation.dart';
import 'package:doctors_ai/widgets/signOutDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'models/users.dart';



Users ? currentUserInfo;



bool isAdmin = false;
User ? user;

int selectedStudent = 0;

bool isAttendanceMarked = false;


Users ? lastLoggedInUser;

DataSnapshot? selectedUser;
String? getSelectedItem = "Basic Computer Skills";
String? getSelectedType = "";
String? getSelectedDepartment = "";

int getDisabilityValue = 0;
int getDemographicValue = 0;
int getCompanyValue = 0;
DateTime? getSelectedDate = DateTime.now();
DateTime today = DateTime.now();
String? lastLoggedIn;
int monthlyPresenceCount = 0;
String? getSelectedAssist = "";

int daysAttended = 0;
double leaveDaysAvailable = 0;
int selectedIndex =0;


displayErrorDialog(String message, BuildContext context){
  showDialog(context: context, builder: (BuildContext context) => ErrorMessageDialog(message: message, ));
}
displayVerifyDialog(String message, BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => VerifyEmailDialog(message: message,));
}
displayDialog(String heading, String message, BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => EmailDialog(heading: heading, message: message, ));
}


displayResetEmailConfirmation(String message, BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => ResetPasswordConfirmation(message: message,));
}
displayForgotPasswordDialog(String message, BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => ForgotPasswordDialog(message: message,));
}

displayChangePasswordDialog(String message, BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => ChangePasswordDialog(message: message,));
}

displayDelete(String employeeKey,String message, BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => DeleteMessageDialog(userName: message,employeeKey: employeeKey,));
}

displayAccept(String employeeKey,String userName, String email, BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => AcceptDialog(userName: userName,employeeKey: employeeKey, email: email,));
}







displaySignOut(BuildContext context){
  showDialog(context: context,
      builder: (BuildContext context) => SignOutDialog());
}



Future<Users?> getCurrentUserInfo() async {
  user = await FirebaseAuth.instance.currentUser;

  final event = await usersRef.child(user!.uid).once();
  final datasnapshot = event.snapshot;

  if (datasnapshot.value != null) {
    currentUserInfo = await Users.fromSnapshot(datasnapshot);


    return currentUserInfo;
  }

  return null;
}






