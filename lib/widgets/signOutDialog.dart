import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../global_methods.dart';
import '../../screens/login_screen/login_screen.dart';


class SignOutDialog extends StatelessWidget {



  SignOutDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0,),

            Text("SIGN OUT?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),

            SizedBox(height: 22.0,),

            Divider(height: 2.0, thickness: 2.0,),

            SizedBox(height: 16.0,),



            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text("Are you sure you want sign out? ", textAlign: TextAlign.center, style: TextStyle(fontSize: 15,color: Colors.black),),
            ),

            SizedBox(height: 30.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: () async{
                      Navigator.pop(context,"close");



                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Cancel", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold ,color: Colors.white),),
                          Icon(Icons.cancel, color: Colors.white, size: 26.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: ElevatedButton(
                    onPressed: () async{

                      await FirebaseAuth.instance.signOut().then((_) {

                        currentUserInfo = null;


                        // Clear cached user information by setting the user to null
                        FirebaseAuth.instance.userChanges().listen((user) {
                          if (user == null) {
                            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                          }
                        });
                      }).catchError((error) {
                        // Handle any errors that occur during sign-out
                        displayErrorDialog("Error signing out: $error", context);
                        // You can show an error message to the user if needed
                      });





                    },
                    style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.red
                    ),
                    child: Padding(

                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text("Yes", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold ,color: Colors.white),),
                          Icon(Icons.logout, color: Colors.white, size: 26.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30.0,),



          ],
        ),
      ),
    );
  }
}
