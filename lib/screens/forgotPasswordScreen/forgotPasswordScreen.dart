
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';

import '../../../components/custom_buttons.dart';
import '../../../constants.dart';
import '../../../global_methods.dart';



late bool _passwordVisible;
late bool _confirmPasswordVisible;

class ForgotPasswordScreen extends StatefulWidget {
  static String routeName = 'ForgotPasswordScreen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //validate our form now
  final _formKey = GlobalKey<FormState>();
  bool otherWidget = false;
  int _otherValue = 0;
  late String _name;
  TextEditingController nameText = TextEditingController();

  String selectedImagePath = '';
  String imageUrl = '';

  //changes current state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
    _confirmPasswordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //when user taps anywhere on the screen, keyboard hides
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: 100.w,
              height: 35.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Text('Reset Password', style: TextStyle(fontSize: 20),),
                  sizedBox,
                  Image.asset(
                    'assets/images/iec-removebg.png',
                    height: 25.h,
                    width: 50.w,
                  ),

                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                decoration: BoxDecoration(
                  color: kOtherColor,
                  //reusable radius,
                  borderRadius: kTopBorderRadius,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        sizedBox,
                        buildEmailField(),
                        sizedBox,

                        DefaultButton(
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              resetPassword(context);
                              Navigator.pop(context);
                              displayResetEmailConfirmation("An email with a link to reset your password has been sent to your email address.", context);
                            }
                          },
                          title: 'Submit',
                          iconData: Icons.arrow_forward_outlined,
                        ),
                        sizedBox,

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> resetPassword(BuildContext context) async{
    _firebaseAuth.sendPasswordResetEmail(email: nameText.text.trim());
  }


  TextFormField buildEmailField() {
    return TextFormField(
      controller: nameText,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Email',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        //for validation
        RegExp regExp = new RegExp(emailPattern);
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
          //if it does not matches the pattern, like
          //it not contains @
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
    );
  }







}
