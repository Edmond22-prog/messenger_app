//classe pour gérer les messages que l'utilisateur recevra en cours discussion
class NewMessageParam {
  NewMessageParam({required this.message, required this.sender});

  final String message;
  final String sender;

  factory NewMessageParam.fromJson(Map<dynamic, dynamic> json) {
    return NewMessageParam(message: json['message'], sender: json['sender']);
  }
}