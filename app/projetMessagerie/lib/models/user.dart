import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String pseudo;
  final String phone;

  const User({
    this.id,
    required this.pseudo,
    required this.phone,
  });

  toJson() {
    return {
      "Pseudo": pseudo,
      "Phone": phone,
    };
  }

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return User(
      id: doc.id,
      pseudo: data['Pseudo'],
      phone: data['Phone'],
    );
  }
}