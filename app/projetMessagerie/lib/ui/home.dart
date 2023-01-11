import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:projetmessagerie/ui/homecontent.dart';
import 'package:projetmessagerie/ui/messagerie.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

///////////////////////////////

/*
class ChatModel{
  final String avatarUrl;
  final String nom;
  final String datetime;
  final String message;
  final bool isOnLigne;

  ChatModel({required this.avatarUrl, required this.nom, required this.datetime, required this.message, required this.isOnLigne});
}
*/

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

//classe recupérée par le sockket lorsque l'utilisateur voudra envoyer un msg
class SocketParam {
  SocketParam({required this.message, required this.receiver});
  final String message;
  final String receiver;

  Map toJson() => {
        'message': message,
        'receiver': receiver,
      };
}

//classe pour gérer les messages que l'utilisateur recevra en cours discussion
class NewMessageParam{
  NewMessageParam({required this.message, required this.sender});
  final String message;
  final String sender;
   factory NewMessageParam.fromJson(Map<dynamic, dynamic> json) {
    return NewMessageParam(
      message: json['message'],
      sender: json['sender']
    );
  }
}

class _MyHomePageState extends State<HomePage> {
  //pseudo de l'utilisateur
  String pseudo =
      ["steph", "loic", "loic", "steph", "loic", "steph"][Random().nextInt(6)];

  //variable socket qui sera utilisée pour faire toutes les transactions nécessitant les sockets
  late IO.Socket socket;

  List<InChatModel> mesConvData = [];

  /*static final List<ChatModel> maConvData = [
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc",
        datetime: "20:18",
        message: "bonjour",
        isOnLigne: true
    ),
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "jean",
        datetime: "20:20",
        message: "comment vas tu ?",
        isOnLigne: true
    ),
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "luc",
        datetime: "20:19",
        message: "helloooooooo",
        isOnLigne: false
    ),
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc3",
        datetime: "20:50",
        message: "hum......",
        isOnLigne: true
    ),

  ];*/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    connect();
  }

  bool verifyUsers(List<String> userList, String user) {
    var _userFound = userList.firstWhereOrNull((elt) => elt == user);
    if (_userFound == null) {
      return false;
    } else {
      return true;
    }
  }

  void connect() {
    //se connecter au socet
    socket = IO.io("http://localhost:300", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    //verifier si on est connecté ou pas
    socket.onConnect((data) {
      print("connected");
      //envoyer notre pseudo au socket
      socket.emit("pseudo", pseudo);
      socket.emit("oldWhispers", pseudo);

      //recupère  les anciens messages et les affiche
      socket.on("oldWhispers", (messages) {
        final List<ChatSocketsModel> listChat = [];
        final List<String> listUsers = [];
        final List<InChatModel> inChatList = [];
        bool found;
        for (final message in messages) {
          var chat = ChatSocketsModel.fromJson(Map.from(message));
          listChat.add(chat);
          found = verifyUsers(listUsers, chat.sender);
          if (!found && chat.sender != pseudo) {
            listUsers.add(chat.sender);
          }

          found = verifyUsers(listUsers, chat.receiver);
          if (!found && chat.receiver != pseudo) {
            listUsers.add(chat.receiver);
          }
        }

        //après avoir eu la liste des utilisateurs on parcours cela et on rechercher les messages
        for (final user in listUsers) {
          var userMessages = listChat
              .where((elt) => elt.sender == user || elt.receiver == user)
              .toList();
          final List<MessageModel> listMessage = [];
          //on parcours la liste des messages et on les transforme pour qu'ils soient du mm type que message model
          for (final message in userMessages) {
            var date = DateTime.parse(message.createdAt);
            String formattedTime = DateFormat.Hm().format(date);
            listMessage.add(MessageModel(
                datetime: formattedTime,
                message: message.content,
                EnvMessage: message.sender != pseudo ? false : true,
                etat: true));
          }

          //maintenant on entre les données telle qu'elles vont ètre affichées
          inChatList.add(InChatModel(
              avatarUrl: "img/pp.png",
              nom: user,
              listmessage: listMessage,
              isOnLigne: true));
        }
        setState(() {
          mesConvData = inChatList;
        });
      });

      socket.on("whisper", (content) {
        var chatReceived = NewMessageParam.fromJson(Map.from(content));
        print(mesConvData);
      });

      //on vérifie si il y'a un nouvel utilisateur
      socket.on("newUser", (pseudo) {
        print("new user " + pseudo);
      });

      // On check si le user se déconnecte
      socket.on("quitUser", (message) {
        print("user quit");
      });
    });

    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  void sendMessage(String message, String receiver) {
    SocketParam newMessage = SocketParam(message: message, receiver: receiver);
    socket.emit("newMessage", jsonEncode(newMessage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: mesConvData.length, //nombre de messages dans la bd
          itemBuilder: (context, index) {
            InChatModel _model = mesConvData[index];
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return MyMessagePage(lechoix: _model, send: sendMessage);
                }));
              },
              child: HomeContent(
                photoprofile: _model.avatarUrl,
                nom: _model.nom,
                lastmessage: _model.lastMessage().message,
                heurelastmessage: _model.lastMessage().datetime,
                enLigne: _model.isOnLigne,
              ),
            );
          }),
    );
  }
}
