import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'dart:io';
import '../../components/custom_buttons.dart';
import '../../constants.dart';

import '../../global_methods.dart';
import '../../main.dart';

late bool _passwordVisible;
late bool _confirmPasswordVisible;

class RegisterScreen extends StatefulWidget {
  static String routeName = 'RegisterScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //validate our form now
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late String _name;
  TextEditingController nameText = TextEditingController();

  TextEditingController surnameText = TextEditingController();
  TextEditingController idText = TextEditingController();
  TextEditingController idDocText = TextEditingController();
  TextEditingController provinceText = TextEditingController();
  TextEditingController cellText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController confirmPasswordText = TextEditingController();
  List<Map> candidates = [];
  List<Map> filteredCandidates = [];
  String selectedPDFPath = '';
  String pdfUrl = '';
  String? idValidationMessage;

  //changes current state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
    _confirmPasswordVisible = true;
    fetchProvinces();
  }

  void fetchProvinces(){
    queryProvinces.onValue.listen((event) {
      setState(() {
        candidates.clear();
        filteredCandidates.clear();
        if (event.snapshot.value != null) {
          Map<dynamic, dynamic> values = event.snapshot.value as Map;
          values.forEach((key, value) {
            Map inspection = value as Map;
            inspection['key'] = key;
            candidates.add(inspection);
          });
          filteredCandidates.addAll(candidates);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //when user taps anywhere on the screen, keyboard hides
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
      appBar: AppBar(
        title: Text('Create an account'),
      ),
        body: Column(
          children: [
            sizedBox,
            sizedBox,
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
                        buildNameField(), // Add the name field here
                        sizedBox,
                        buildSurnameField(), // Add the surname field here
                        sizedBox,
                        buildIDField(),
                        sizedBox,

                        buildEmailField(),
                        sizedBox,

                        buildCellField(),
                        sizedBox,
                        buildPasswordField(),
                        sizedBox,
                        buildConfirmPasswordField(),
                        sizedBox,
                        DefaultButton(
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              registerUser(context);

                            }
                          },
                          title: 'Create Account',
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

  void registerUser(BuildContext context) async{
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(child: CircularProgressIndicator(
            color: kPrimaryColor,
          ));
        }
    );


    final User? user = (await _firebaseAuth.createUserWithEmailAndPassword(email: emailText.text.trim(), password: passwordText.text.trim())
        .catchError((errMsg) {
      Navigator.pop(context);


      displayErrorDialog(errMsg.toString(), context);
      return Future<UserCredential>.error(errMsg); // Return an error future
    })
    ).user;



    final DateTime timestamp = DateTime.timestamp();
    if(user!= null){
      Map userDataMap = {
        "name": nameText.text.trim(),
        "surname": surnameText.text.trim(),
        "id": idText.text.trim(),
        "email": emailText.text.trim(),
        "phone": cellText.text.trim(),
        "pdf": pdfUrl.toString().trim(),

        "timestamp": timestamp.toString(),

      };
      usersRef.child(user.uid).set(userDataMap);

      // lastLoggedInUser = currentUserInfo;

      user.sendEmailVerification();
      FirebaseAuth.instance.signOut();
      // await _firebaseAuth.signInWithEmailAndPassword(email: lastLoggedInUser!.email, password: lastLoggedInUser!.password);




      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      Navigator.pop(context);

      displayVerifyDialog("An email verification has been sent to " + emailText.text, context);

    }else{
      Navigator.pop(context);
      displayErrorDialog("Failed to register account.", context);

    }
  }


  Future<String?> checkIDExists(String id) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    // Use onValue to listen for changes and handle the response
    databaseReference.child('users').orderByChild('id').equalTo(id).onValue.listen((event) {
      if (event.snapshot.value != null) {
        // ID exists in the database
        Map<dynamic, dynamic> usersData = event.snapshot.value as Map;
        // Handle the data or return a message
        print('ID number already exists');
          idValidationMessage = 'ID number already exists';
      } else {
        // ID does not exist in the database
        print('ID does not exist');
        idValidationMessage = '';

      }
    });
    return null; // Asynchronous method, return null by default
  }


  selectPdfFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Specify the allowed file extensions (e.g., 'pdf', 'doc', 'txt', etc.).
    );

    if (result != null) {
      PlatformFile file = result.files.single;
      // Check the selected file here, and you can use file.path to get the file path.
      setState(() {
        selectedPDFPath = file.path!;
        idDocText.text = file.name; // Set the file name in the idDocText field.
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No file selected!"),
        ),
      );
    }
  }



  TextFormField buildDocumentField() {
    return TextFormField(
      controller: idDocText,
      onTap: () => selectPdfFromGallery(),
      textAlign: TextAlign.start,
      readOnly: true,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Upload ID Document',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.upload_file,
        )
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please upload your ID document';
        }
        return null;
      },
    );
  }

  TextFormField buildProvinceField() {
    return TextFormField(
      controller: provinceText,
      onTap: () => _showDialog(),
      textAlign: TextAlign.start,
      readOnly: true,
      style: kInputTextStyle,
      decoration: InputDecoration(
          labelText: 'Select Province',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(
            Icons.location_on,
          )
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please select a province';
        }
        return null;
      },
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
          return 'Please enter some text';
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
          return 'Must be more than 5 characters';
        }
      },
    );
  }
  TextFormField buildConfirmPasswordField() {
    return TextFormField(
      controller: confirmPasswordText,
      obscureText: _confirmPasswordVisible,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _confirmPasswordVisible = !_confirmPasswordVisible;
            });
          },
          icon: Icon(
            _confirmPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility,
          ),
          iconSize: kDefaultPadding,
        ),
      ),
      validator: (value) {
        if (value!.length < 5) {
          return 'Must be more than 5 characters';
        }else if (passwordText.text.trim() != confirmPasswordText.text.trim()){
          return 'Passwords do not match';
        }
      },
    );
  }
  TextFormField buildNameField() {
    return TextFormField(
      controller: nameText,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Name',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
      },
    );
  }
  TextFormField buildCellField() {
    return TextFormField(
      controller: cellText,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.phone,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Phone',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your cell number';
        }else if(value.length != 10){
          return 'Cell number should have 10 digits';
        }
      },
    );
  }

  TextFormField buildIDField() {
    return TextFormField(
      controller: idText,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.phone,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'ID number',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      onChanged: (value) {
        // Validate the ID whenever it's changed
        validateID(idText.text);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your identity number';
        }else if(value.length != 13){
          return 'ID number should have 13 digits';
        }
        else if(idValidationMessage!.isNotEmpty){
          return idValidationMessage;
        }
      },
    );
  }

  void validateID(String id) async {
    idValidationMessage = await checkIDExists(id);
    // Force the form to re-validate and update the UI

  }


  TextFormField buildSurnameField() {
    return TextFormField(
      controller: surnameText,
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      style: kInputTextStyle,
      decoration: InputDecoration(
        labelText: 'Surname',
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your surname';
        }
      },
    );
  }

  Widget listItem({required Map trainee}) {
    return GestureDetector(
      onTap: (){
        setState(() {
          provinceText.text = trainee['name'];
        });
        Navigator.pop(context);

      },
      child: ListTile(
        leading: Icon(Icons.location_on, color: kPrimaryColor,),
        title: Text(trainee['name'], style: Theme.of(context).textTheme.subtitle2?.copyWith(
          color: kTextBlackColor,
        )),
      ),
    );


  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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

                Text('Select a province',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),),

                SizedBox(height: 22.0,),

                Divider(height: 2.0, thickness: 2.0,),

                Padding(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: filteredCandidates.isEmpty
                        ? Center(
                      child: Text('No provinces found.', style: TextStyle(color: kPrimaryColor, fontSize: 15),),
                    )
                        : ListView.builder(
                      itemCount: filteredCandidates.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map inspection = filteredCandidates[index];
                        return listItem(trainee: inspection);
                      },
                    ),
                  ),
                ),

                // Column(
                //   children: widget.students
                //       .asMap()
                //       .entries
                //       .map((entry) {
                //     final index = entry.key;
                //     final studentYear = entry.value;
                //     return ListTile(
                //       title: Text(studentYear, style: Theme.of(context).textTheme.subtitle2?.copyWith(
                //         color: kTextBlackColor,
                //       )),
                //       onTap: () async {
                //
                //         setState(() {
                //           selectedStudent = index;
                //           getCurrentUserInfo();
                //
                //
                //         });
                //
                //         Navigator.of(context).pop();
                //
                //       },
                //     );
                //   })
                //       .toList(),
                // ),



              ],
            ),
          ),
        );


      },
    );
  }


}
