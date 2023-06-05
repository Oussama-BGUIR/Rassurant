
// ignore_for_file: unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rassurant/screens/interface.dart';
import 'package:rassurant/screens/signin_screen.dart';
import 'package:rassurant/screens/signup_screen.dart';
import 'package:rassurant/screens/updateusers.dart';
import '../utils/color_utils.dart';

class interadmin extends StatefulWidget {
  const interadmin({Key? key}) : super(key: key);

  @override
  _interadminState createState() => _interadminState();
}
List<Object> _ListUser = [];
class _interadminState extends State<interadmin> {
  @override
  Widget build(BuildContext context) {
    
      return Stack(
      children: [
        Scaffold(
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
          "Espace Admin",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 20,
        actions: [
          IconButton(icon : Icon(Icons.add_to_home_screen_outlined),
           onPressed: () {
           FirebaseAuth.instance.signOut().then((value) {
              print("acceder à l'interface"); 
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => inter()));
            });
          },
           ),
          IconButton(icon : Icon(Icons.logout),
           onPressed: () {
           FirebaseAuth.instance.signOut().then((value) {
              print("Sortir"); 
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            });
          },
          ),

        ],
        
      ),
      
          body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('volontaires').snapshots(),
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
                      leading: const Icon(
                        Icons.person,
                        size: 40,
                      ),
                      iconColor: const Color.fromARGB(255, 0, 0, 0),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //! update !!!!!
                          IconButton(
                         onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => updateusers(
                                            nom: data['nom'],
                                            id: data['uid'],
                                            password: data['mot de passe'],
                                            email: data["email"],
                                            numero: data["numero"],
                                            location: data["localisation"],
                                          )));
                            },
   
              //          onPressed: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const updateusers()));
              // },
                            icon: const Icon(Icons.file_upload_outlined),
                            iconSize: 30,
                            color: const Color.fromARGB(255, 14, 167, 1),
                          ),
                          //!Dellete
                          IconButton(
                            onPressed: () async {
                              final collection = FirebaseFirestore.instance
                                  .collection("volontaires")
                                  .doc(document.id)
                                  .delete();

                            },
                            icon: const Icon(Icons.delete),
                            iconSize: 30,
                            color: Colors.red,
                          )
                        ],
                      ),
                      title: Text(
                        " Nom & Prénom :  ${data['nom']} \n Email :  ${data['email']} \n Mot de passe :  ${data['mot de passe']} \n numéro de téléphone :  ${data['numero']}  \n Localisation :  ${data['localisation']}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Roboto",
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ),
                      minVerticalPadding: 30,
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            
            child: Material(
           
           elevation: 5,
      borderRadius: BorderRadius.circular(90),
      color: Colors.purple,
              child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 00.0),
          minWidth: MediaQuery.of(context).size.width,
           onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              },
                child: Text(
            "Ajouter un volontaire",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
          ),),
             
             
            ),
          ),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }
}
