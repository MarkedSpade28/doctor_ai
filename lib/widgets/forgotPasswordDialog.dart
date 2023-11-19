import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../global_methods.dart';





class ForgotPasswordDialog extends StatefulWidget {
  final String message;

  ForgotPasswordDialog({required this.message});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  bool tValue = false;

  final _formKey = GlobalKey<FormState>();

  late String _name;

  TextEditingController emailText = TextEditingController();

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
          color:kPrimaryColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0,),

              Text("Reset Password", style: TextStyle( fontWeight: FontWeight.bold,color: Colors.white), ),

              SizedBox(height: 22.0,),

              Divider(height: 2.0, thickness: 2.0,),


              SizedBox(height: 16.0,),




              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[


                    Container(
                      alignment: Alignment.centerLeft,

                      height: 60.0,
                      child: TextFormField(
                        controller: emailText,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 14.0),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          hintText: 'Enter your Email',

                        ),
                      ),
                    ),
                    Visibility(
                        visible: tValue == true,
                        child: Text("Please enter your email", style: TextStyle(color: Colors.red),)
                    ),

                  ],
                ),
              ),


              SizedBox(height: 20.0,),

              Container(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(05.0),
                    ),

                  ),

                  onPressed: () async{

                    if(emailText.text.isEmpty){
                      setState(() {
                        tValue =true;
                      });

                    }
                    else{
                      resetPassword(context);
                      Navigator.pop(context);
                      displayResetEmailConfirmation("An email with a link to reset your password has been sent to your email address.", context);
                    }









                  },
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),





            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void resetPassword(BuildContext context) async{
    _firebaseAuth.sendPasswordResetEmail(email: emailText.text.trim());
  }
}


