
import 'package:doctors_ai/routes.dart';
import 'package:doctors_ai/screens/splash_screen/splash_screen.dart';
import 'package:doctors_ai/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'global_methods.dart';




DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference natCandidatesRef = FirebaseDatabase.instance.ref().child("national_candidates");
DatabaseReference provCandidatesRef = FirebaseDatabase.instance.ref().child("provincial_candidates");
DatabaseReference provincesRef = FirebaseDatabase.instance.ref().child("provinces");




Query queryNatCandidates = natCandidatesRef;
Query queryProvCandidates = provCandidatesRef;
Query queryProvinces = provincesRef;
Query queryPendingApplications = usersRef.orderByChild('status').equalTo('pending');
Query queryRegisteredVoters = usersRef.orderByChild('status').equalTo('accepted');
Query queryUsers = usersRef.orderByChild('type').equalTo('voter');























void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  if(FirebaseAuth.instance.currentUser != null){
    await getCurrentUserInfo();

  }

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //it requires 3 parameters
    //context, orientation, device
    //it always requires, see plugin documentation
    return Sizer(builder: (context, orientation, device){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Homework',
        theme: CustomTheme().baseTheme,
        //initial route is splash screen
        //mean first screen
        initialRoute: SplashScreen.routeName,
        //define the routes file here in order to access the routes any where all over the app
        routes: routes,
      );
    });
  }
}
