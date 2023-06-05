// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rassurant/blocs/appbloc.dart';
import 'package:rassurant/screens/interface.dart';
import 'package:rassurant/screens/signin_screen.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';







class pulsation extends StatefulWidget {
  const pulsation({Key? key}) : super(key: key);

  @override
  _pulsationState createState() => _pulsationState();
}


class _pulsationState extends State<pulsation> {
 @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
       flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
        ),
        title: const Text(
          "pulsation",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 20,
        actions: [
          IconButton(icon : Icon(Icons.logout),
           onPressed: () {
           FirebaseAuth.instance.signOut().then((value) {
              print("retourner"); 
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => inter()));
            });
          },

          ),
        ],
        
      ),





// body : SingleChildScrollView ( 
//   child : Stack(

//     children: [
//       const SizedBox(height: 25.0),
// Center( 
//  child: Container(
//                       height: 380,
//                       margin: const EdgeInsets.only(
//                         top: 50,
//                       ),
//                       child: Image.asset('assets/images/pulsation.png'),
//                     ),

//                   ),              
//               print(getPulsation()),
              
//             ],
//             ),
// ),






                 

   body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('pulsation').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots) {
              if (snapshots.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }



              return SafeArea(
                
                child: ListView(
                  children: snapshots.data!.docs
                      .toList()
                      .map<Widget>((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return new ListTile(

                      title: Text(
                        " La pulsation :  ${data['pulsation']}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 20),
                      ),
                      minVerticalPadding: 12,
                    );
                  }).toList(),
                ),
              );
            },
          ),


          );
  }

}