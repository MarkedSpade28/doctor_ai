import 'package:flutter/material.dart';

import '../../constants.dart';

class EmailDialog extends StatelessWidget {
  final String message, heading;


  EmailDialog({required this.heading,required this.message});

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

            Text(heading,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),

            SizedBox(height: 22.0,),

            Divider(height: 2.0, thickness: 2.0,),


            SizedBox(height: 16.0,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.black),),
            ),

            SizedBox(height: 30.0,),

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
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Close", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold ,color: Colors.white),),
                      Icon(Icons.verified, color: Colors.white, size: 26.0),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.0,),



          ],
        ),
      ),
    );
  }
}

