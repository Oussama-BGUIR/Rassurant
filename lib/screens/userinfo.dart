// ignore_for_file: file_names
class UserModel {
  String? uid;
  String? email;
  String? nom;
  String? password;
  String? localisation;
  String? numero;
  UserModel({this.uid, this.email, this.nom, this.password, this.localisation, this.numero});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nom: map['nom'],
      numero: map['numero'],
      password: map['mot de passe'],
      localisation: map['localisation'],
    );
  }
  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nom': nom,
      'numero': numero,
      'mot de passe': password,
      'localisation': localisation
    };
  }
}