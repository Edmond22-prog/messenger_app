//classe recupérée par le socket lorsque l'utilisateur voudra envoyer un msg
class SocketParam {
  SocketParam({required this.message, required this.receiver});

  final String message;
  final String receiver;

  Map toJson() => {
    'message': message,
    'receiver': receiver,
  };
}