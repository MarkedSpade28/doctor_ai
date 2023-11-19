import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../constants.dart';
import '../../main.dart';



class AcceptDialog extends StatefulWidget {
  final String userName;
  final String employeeKey;
  final String email;


  AcceptDialog({required this.userName, required this.employeeKey, required this.email});

  @override
  State<AcceptDialog> createState() => _AcceptDialogState();
}

class _AcceptDialogState extends State<AcceptDialog> {
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

            Text("Accept?", style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),),

            SizedBox(height: 22.0,),

            Divider(height: 2.0, thickness: 2.0,),

            SizedBox(height: 16.0,),



            SizedBox(height: 16.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text("Do you want to accept " + widget.userName + "\'s application?", textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: 17),),
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
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return Center(child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ));
                          }
                      );
                      Map<String, String> employees = {
                        'status': 'accepted',


                      };



                      await usersRef.child(widget.employeeKey).update(employees)
                          .then((value) => {



                      });

                      await sendEmail();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Application Accepted"),
                      ));
                      Navigator.pop(context,"close");
                      Navigator.pop(context,"close");



                    },
                    style: ElevatedButton.styleFrom(

                        backgroundColor: kPrimaryColor
                    ),
                    child: Padding(

                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text("Yes", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold ,color: Colors.white),),
                          Icon(Icons.check, color: Colors.white, size: 26.0),
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

  Future<void> sendEmail() async {
    final smtpServer = gmail('2021bookmarket@gmail.com', 'uqzuaofngkfmxuir'); // Replace with your email and password

    final message = Message()
      ..from = Address('evote@elections.org.za', 'E-Vote')
      ..recipients.add(widget.email)
      ..subject = 'Application Accepted'
      ..html = '''
        <html>
          <body>
            <p>Dear ${widget.userName},</p>
            <p>Your application has been accepted, and you may now exercise your right to vote. Remember, your vote is your confidential privilege. </p>
            
            <p>Kind regards,</p>
            <p>E-Vote Team</p>
            <img src="https://firebasestorage.googleapis.com/v0/b/e-vote-71a1c.appspot.com/o/images%2Flogo.png?alt=media&token=eb8cfb18-f586-4119-8123-02d5e8b6a9f5&_gl=1*1sbgwgo*_ga*MTc2NjkwOTAwMy4xNjk3MzYxMDM1*_ga_CW55HF8NVT*MTY5OTMzNjAxNi40Ny4xLjE2OTkzMzYwMzkuMzcuMC4w" alt="Banner Image">
          </body>
        </html>
      ''';


    try {
      final sendReport = await send(message, smtpServer);

    } on MailerException catch (e) {
      print('Message not sent. Error: ${e.message}');
    }
  }
}
