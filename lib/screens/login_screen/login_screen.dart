
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


import '../../components/custom_buttons.dart';
import '../../constants.dart';
import '../../global_methods.dart';
import '../../main.dart';
import '../forgotPasswordScreen/forgotPasswordScreen.dart';
import '../home_screen/home_screen.dart';
import '../register_screen/register_screen.dart';


late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //validate our form now
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();

  //changes current state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
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

                  Center(
                    child: Image.asset(
                      'assets/images/logo ai.png',
                      height: 50.h,
                      width: 70.w,
                    ),
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
                        buildPasswordField(),
                        sizedBox,
                        DefaultButton(
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              loginUser(context);
                            }
                          },
                          title: 'SIGN IN',
                          iconData: Icons.arrow_forward_outlined,
                        ),
                        sizedBox,
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(
                                context, ForgotPasswordScreen.routeName);
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Forgot Password?',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        sizedBox,
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(
                                context, RegisterScreen.routeName);
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "Don't have an account? Create an account",
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w100),
                            ),
                          ),
                        ),
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

  TextFormField buildEmailField() {
    return TextFormField(
      controller: emailText,
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
          return 'Please enter your email';
          //if it does not matches the pattern, like
          //it not contains @
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: passwordText,
      obscureText: _passwordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility,
          ),
          iconSize: kDefaultPadding,
        ),
      ),
      validator: (value) {
        if (value!.length < 5) {
          return 'Please enter your password';
        }
      },
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginUser(BuildContext context) async{
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(child: CircularProgressIndicator(
            color: kPrimaryColor,
          ));
        }
    );





    final User? user = (await _firebaseAuth.signInWithEmailAndPassword(email: emailText.text.trim(), password: passwordText.text.trim()).catchError((errMsg){


      Navigator.pop(context);
      displayErrorDialog(errMsg.toString(), context);
      return Future<UserCredential>.error(errMsg); // Return an error future



    }) ).user;


    if(user!= null){
      if(user.emailVerified == true){
        usersRef.child(user.uid).once().then((event) async {
          final datasnapshot = event.snapshot;

          if(datasnapshot.value !=null){
            getCurrentUserInfo();


            Navigator.pop(context);
             Navigator.pushNamedAndRemoveUntil(context,
                 HomeScreen.routeName, (route) => false);









          }else{
            await _firebaseAuth.signOut();
            Navigator.pop(context);
            displayErrorDialog("Your account does not exist.", context);


          }
        });


      }else{
        await _firebaseAuth.signOut();
        Navigator.pop(context);
        displayDialog("Oops","Please verify your email before signing in.", context);


      }
    }
    else{
      await _firebaseAuth.signOut();
      Navigator.pop(context);
      displayErrorDialog("User cannot be signed in.", context);

    }




  }
}

