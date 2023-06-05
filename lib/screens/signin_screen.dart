import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rassurant/screens/interface.dart';
import 'package:rassurant/screens/reset_password.dart';
import 'package:rassurant/screens/signup_screen.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../utils/color_utils.dart';
import 'authadmin.dart';




class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

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
                } else if ((val.isEmpty)) return 'veuillez entrer votre email';
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
          signIn(_emailTextController.text, _passwordTextController.text);
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
                  logoWidget("assets/images/blackhands.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  emailField,
                  SizedBox(height: 30),
            
                  passwordField,
                  SizedBox(height: 20),
            
            
                  forgetPassword(context),
            
                  SizedBox(height: 10 ),
                  
                  signInButton,
                  SizedBox(height: 30),
            
            
                  
                  signUpOption(),
                  SizedBox(height: 30),
            
                  admin()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Connexion réussie"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => inter())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Votre adresse e-mail semble être malformée.";

            break;
          case "wrong-password":
            errorMessage = "Votre mot de passe est erroné.";
            break;
          case "user-not-found":
            errorMessage = "L'utilisateur avec cet email n'existe pas.";
            break;
          case "user-disabled":
            errorMessage = "L'utilisateur avec cet e-mail a été désactivé.";
            break;
          case "too-many-requests":
            errorMessage = "Trop de demandes";
            break;
          case "operation-not-allowed":
            errorMessage =
                "La connexion avec un e-mail et un mot de passe n'est pas activée.";
            break;
          default:
            errorMessage = "Une erreur indéfinie s'est produite.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }


  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("J'ai pas un compte !",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " S'inscrire",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
  

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Mot de passe oublié ?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }


Row admin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Vous êtes un administrateur ? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => authadmin()));
          },
          child: const Text(
            "Accéder à mon espace",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }



}
