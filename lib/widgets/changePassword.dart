
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../global_methods.dart';







class ChangePasswordDialog extends StatefulWidget {
  final String message;


  ChangePasswordDialog({required this.message});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  String errorMessage = "";
  late String _name;


  TextEditingController currentPasswordText = TextEditingController();

  TextEditingController newPasswordText = TextEditingController();

  TextEditingController confirmPasswordText = TextEditingController();


  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Dialog(
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

              Text("Change Password", style: TextStyle( fontWeight: FontWeight.bold),),

              SizedBox(height: 22.0,),

              Divider(height: 2.0, thickness: 2.0,),


              SizedBox(height: 16.0,),


              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(widget.message, textAlign: TextAlign.center,),
              ),
              SizedBox(height: 10.0,),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 1.0,),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter current password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                        controller: currentPasswordText,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Current Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )

                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 1.0,),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your new password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                        controller: newPasswordText,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "New Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )

                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 1.0,),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter confirmation password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                        controller: confirmPasswordText,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            )

                        ),

                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 10.0,),
                      Text(errorMessage, style: TextStyle(color: Colors.red),)



                    ],
                  ),
                ),
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
                          backgroundColor: Colors.red
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

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          changePassword(context);


                        }



                      },
                      style: ElevatedButton.styleFrom(

                          backgroundColor: kPrimaryColor
                      ),
                      child: Padding(

                        padding: EdgeInsets.all(3.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Text("Submit", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold ,color: Colors.white),),
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
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  var currentUser = FirebaseAuth.instance.currentUser;

  void changePassword(BuildContext context) async{
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context){
    //       return ProgressDialog(message: "Please Wait...",);
    //     }
    // );
    if(newPasswordText.text == confirmPasswordText.text){
      String startWord = "]";


      var cred = EmailAuthProvider.credential(email: currentUserInfo!.email, password: currentPasswordText.text.trim());
      await currentUser!.reauthenticateWithCredential(cred).then((value){
        currentUser!.updatePassword(confirmPasswordText.text.trim());
        Navigator.pop(context);
        Navigator.pop(context,"close");
        displayDialog('Success', 'You have successfully updated your password', context);

      }).catchError((error) {
        setState(() {
          int startIndex = error.toString().indexOf(startWord);
          errorMessage = error.toString().substring(startIndex+1);
          Navigator.pop(context);
        });
      });
    }
    else{
      setState(() {
        errorMessage = "Passwords do not match";
        Navigator.pop(context);
      });
    }







  }
}


