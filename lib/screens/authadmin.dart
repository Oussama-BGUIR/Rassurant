//import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';
import 'interadmin.dart';





class authadmin extends StatefulWidget {
  const authadmin({Key? key}) : super(key: key);

  @override
  _authadminState createState() => _authadminState();
}


class _authadminState extends State<authadmin> {
 TextEditingController _emailTextController = TextEditingController();
 TextEditingController _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isSecret = true;
  
  final _auth = FirebaseAuth.instance;
  
  
  // string for displaying the error Message
  String? errorMessage;



   @override
  void dispose() {
    _passwordTextController.dispose();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {


final emailField = TextFormField(
    controller: _emailTextController,
    obscureText: false,

    cursorColor: Colors.white,
  validator: (val) {
                if (!(val!.isEmpty) &&
                    !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                        .hasMatch(val)) {
                  return "entrez une adresse e-mail valide";
                } else if ((val.isEmpty)) { return 'veuillez entrer votre email';
                } else if ( val!="oussama.bguir@ieee.org") {
            return ("entrez l'adresse email correcte d'administrateur");
          }
              },
              onSaved: (value) {
                _emailTextController.text = value!;
              },
 
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.mail,
        color: Colors.white70,
      ),
      labelText: "Email",
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    )
    );

    //password field
    final passwordField = TextFormField(
    controller: _passwordTextController,
    obscureText: _isSecret,
    validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Le mot de passe est requis pour la connexion");
          }
          if (!regex.hasMatch(value)) {
            return ("Entrez un mot de passe valide (min. 6 caractères)");
          }
           if (value!="oussama.admin") {
            return ("Entrez le mot de passe correcte d'administrateur");
          }
        },

    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.vpn_key,
        color: Colors.white70,
      ),
       suffixIcon: InkWell(
            onTap: () => setState(() => _isSecret = !_isSecret),
            child: Icon(
              _isSecret ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
      labelText: 'Mot de passe',
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    )
    );




    //signIn button
    final signInButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(90),
      color: Color.fromARGB(255, 255, 255, 255),
      child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 00.0),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      debugPrint(
                                          'Toutes les validations sont passées !!');
                                      Fluttertoast.showToast(
                                          msg: "Connexion réussie");
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const interadmin()),
                                          (Route<dynamic> route) => false);
                                    }
                                  },
          
          child: Text(
            "Connexion",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )),
    );






    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.15, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/admin.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  emailField,
                  SizedBox(height: 30),
            
                  passwordField,
                  SizedBox(height: 70),

                  signInButton,
                  SizedBox(height: 30),
            
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  }
  