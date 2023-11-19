import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../main.dart';



class DeleteMessageDialog extends StatelessWidget {
final String userName;
final String employeeKey;


  DeleteMessageDialog({required this.userName, required this.employeeKey});

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

            Text("Delete Candidate?", style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: kPrimaryColor),),

            SizedBox(height: 22.0,),

            Divider(height: 2.0, thickness: 2.0,),

            SizedBox(height: 16.0,),



            SizedBox(height: 16.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text("Do you want to delete " + userName + "?", textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor, fontSize: 25),),
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
                      natCandidatesRef.child(employeeKey).remove();
                      provCandidatesRef.child(employeeKey).remove();
                      usersRef.child(employeeKey).remove();
                      provincesRef.child(employeeKey).remove();

                      Navigator.pop(context,"close");



                    },
                    style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.red
                    ),
                    child: Padding(

                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text("Delete", style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold ,color: Colors.white),),
                          Icon(Icons.delete, color: Colors.white, size: 26.0),
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
