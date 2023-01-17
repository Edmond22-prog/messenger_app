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
}