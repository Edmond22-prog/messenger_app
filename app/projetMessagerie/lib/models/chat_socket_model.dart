class ChatSocketsModel {
  final String createdAt;
  final String sender;
  final String receiver;
  final String content;

  ChatSocketsModel(
      {required this.createdAt,
        required this.sender,
        required this.receiver,
        required this.content});

  factory ChatSocketsModel.fromJson(Map<dynamic, dynamic> json) {
    return ChatSocketsModel(
      createdAt: json['createdAt'],
      sender: json['sender'],
      receiver: json['receiver'],
      content: json['content'],
    );
  }
}