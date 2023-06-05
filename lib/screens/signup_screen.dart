import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rassurant/screens/signin_screen.dart';
import 'package:rassurant/screens/userinfo.dart';

import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';

import 'interface.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
 final _auth = FirebaseAuth.instance;
   
  bool _isSecret = true;
  bool _isSecretCon = true;
  // string for displaying the error Message
  String? errorMessage;

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _locationTextController = TextEditingController() ;
  TextEditingController _numTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController =  TextEditingController();


  @override
  Widget build(BuildContext context) {

    //nom et prenom

     final NameField = TextFormField(
    controller: _userNameTextController,
    obscureText: false,

    cursorColor: Colors.white,
    validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("veuillez entrer votre nom d'utilisateur");
          }
          if (!regex.hasMatch(value)) {
            return ("Entrez un nom valide (Min. 3 caractères)");
          }
          return null;
        },
        onSaved: (value) {
         _userNameTextController.text = value!;
       },
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.person_outline,
        color: Colors.white70,
      ),
      labelText: "Nom et prénom",
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),



  );

//location field
       final locationField = TextFormField(
    controller: _locationTextController,
    obscureText: false ,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("veuillez entrer votre localisation");
          }
          if (!regex.hasMatch(value)) {
            return ("Entrez une localisation valide (Min. 3 caractères)");
          }
          return null;
        },
        onSaved: (value) {
         _locationTextController.text = value!;
       },
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.location_on,
        color: Colors.white70,
      ),
      labelText: "Localisation",
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
  );

//numéro de téléphone

final NumField = TextFormField(
    controller: _numTextController,
    obscureText: false ,
    keyboardType: TextInputType.phone,
    validator: (value) {
        RegExp regex = new RegExp(r'0123456789');
        if (value!.isEmpty) {
          return "veuillez entrer votre numéro de téléphone";
        } else if (value.length < 8) {
          return "entrer un numéro de téléphone valide";
        }
        return null;
      },
      onSaved: (value) {
        _numTextController.text = value!;
      },
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
        prefixIcon: Padding(
          child: CountryCodePicker(
            flagWidth: 24,
            showCountryOnly: true,
            showOnlyCountryWhenClosed: false,
            favorite: ['+216', 'TN'],
            initialSelection: 'TN',
            hideMainText: true,
            showFlagMain: true,
          ),
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
        ),
      labelText: "Numéro de téléphone",
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
  );


    //email field

    final emailField = TextFormField(
    controller: _emailTextController,
    obscureText: false,

    cursorColor: Colors.white,
    validator: (value) {
          if (value!.isEmpty) {
            return ("veuillez entrer votre email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Veuillez entrer un email valide");
          }
          return null;
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
        },
        onSaved: (value) {
          _passwordTextController.text = value!;
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
    
    

    //confirm password field
    final confirmPasswordField = TextFormField(
    controller: _confirmPasswordTextController,
    obscureText: _isSecretCon,    
    validator: (value) {
        if (_confirmPasswordTextController.text !=
            _passwordTextController.text) {
          return "Le mot de passe ne correspond pas";
        }
        return null;
      },
      onSaved: (value) {
        _confirmPasswordTextController.text = value!;
      },
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.vpn_key,
        color: Colors.white70,
      ),
       suffixIcon: InkWell(
            onTap: () => setState(() => _isSecretCon = !_isSecretCon),
            child: Icon(
              _isSecretCon ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
      labelText: "Confirmez votre mot de passe",
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    )
    );
    

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(90),
      color: Color.fromARGB(255, 255, 255, 255),
      child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 00.0),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
          signUp(_emailTextController.text, _passwordTextController.text);
          },
          
          child: Text(
            "S'inscrire",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )),
    );




    return Stack(children: [
    
      Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "S'inscrire",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
              child: Form(
                key: _formKey,
                child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                          child: Column(
                
                      children: <Widget>[
                        NameField,
                        SizedBox(height: 20),
              
                        locationField,
                        SizedBox(height: 20),
              
                        NumField,
                        SizedBox(height: 20),
              
                        emailField,
                        SizedBox(height: 20),
              
                        passwordField,
                        SizedBox(height: 20),
              
                        confirmPasswordField,
                        SizedBox(height: 60),
              
                        signUpButton,
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
              ),
              ),
            ),
          ),
    ]);
  }

 
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((uid) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
          
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => SignInScreen()));
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }


  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel account = UserModel();

    // writing all the values
    account.uid = user!.uid;
    account.email = user.email;
    account.nom = _userNameTextController.text;
    account.numero = _numTextController.text;
    account.password = _passwordTextController.text;
    account.localisation = _locationTextController.text;

    await firebaseFirestore
        .collection("volontaires")
        .doc(user.uid)
        .set(account.toMap());
    Fluttertoast.showToast(msg: " Compte cré avec succès:) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (route) => false);
  }
  
}

