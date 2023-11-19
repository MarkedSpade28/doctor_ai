import 'package:firebase_database/firebase_database.dart';



class Users {
  String key, id, email, name,  phone, type, status, surname;


  Users({
    required this.key,
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.type,
    required this.status,

    required this.surname,


  });

  factory Users.fromSnapshot(DataSnapshot dataSnapshot) {
    final key = dataSnapshot.key ?? "";
    final email = (dataSnapshot.value as Map?)?["email"] ?? "";
    final id = (dataSnapshot.value as Map?)?["id"] ?? "";
    final name = (dataSnapshot.value as Map?)?["name"] ?? "";
    final phone = (dataSnapshot.value as Map?)?["phone"] ?? "";

    final type = (dataSnapshot.value as Map?)?["type"] ?? "";

    final status = (dataSnapshot.value as Map?)?["status"] ?? "";

    final surname = (dataSnapshot.value as Map?)?["surname"] ?? "";


   {
      return Users(
        key: key,
        id: id,
        email: email,
        name: name,
        phone: phone,
        type: type,
        status: status,
  
        surname: surname,

      );
    }
  }

}


