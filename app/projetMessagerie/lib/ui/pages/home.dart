import 'package:flutter/material.dart';
import 'package:projetmessagerie/ui/src/contactlist.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:projetmessagerie/ui/pages/homecontent.dart';
import 'package:projetmessagerie/ui/pages/messagerie.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../../models/chat_socket_model.dart';
import '../../models/new_message_param.dart';

class HomeConvPage extends StatefulWidget {
  const HomeConvPage({super.key, required this.pseudo, required this.number});

  final String pseudo;
  final String number;

  @override
  State<HomeConvPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeConvPage> {
  //pseudo de l'utilisateur
  //String pseudo = ["steph", "loic", "loic", "steph", "loic", "steph"][Random().nextInt(6)];

  //variable socket qui sera utilisée pour faire toutes les transactions nécessitant les sockets
  late IO.Socket socket;

  List<InChatModel> mesConvData = [];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    //mesConvData = mesConvDatat;
    connect();
  }

  bool verifyUsers(List<String> userList, String user) {
    var userFound = userList.firstWhereOrNull((elt) => elt == user);
    if (userFound == null) {
      return false;
    } else {
      return true;
    }
  }

  void setMessage(String user, String message, String type) {
    debugPrint("User is $user");
    debugPrint("Message is $message");
    var date = DateTime.now();
    String formattedTime = DateFormat.Hm().format(date);
    //type = "sender" équivaut au pseudo qui envoi le msg  à user et type="receiver"
    for (int i = 0; i < mesConvData.length; i++) {
      if (mesConvData[i].nom == user) {
        debugPrint("Enter here");
        setState(() {
          mesConvData[i].listmessage.add(MessageModel(
              datetime: formattedTime,
              message: message,
              EnvMessage: type == "sender" ? true : false,
              etat: true));
        });
      }
    }
  }

  void connect() {
    //se connecter au socket
    socket = IO.io("http://localhost:300", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    //verifier si on est connecté ou pas
    socket.onConnect((data) {
      debugPrint("Connected");
      //envoyer notre pseudo au socket
      socket.emit("pseudo", widget.pseudo);
      socket.emit("oldWhispers", widget.pseudo);

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
          if (!found && chat.sender != widget.pseudo) {
            listUsers.add(chat.sender);
          }

          found = verifyUsers(listUsers, chat.receiver);
          if (!found && chat.receiver != widget.pseudo) {
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
                EnvMessage: message.sender != widget.pseudo ? false : true,
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
        debugPrint("we are receiving the message");
        var chatReceived = NewMessageParam.fromJson(Map.from(content));
        setMessage(chatReceived.sender, chatReceived.message, "receiver");
      });

      //on vérifie si il y'a un nouvel utilisateur
      socket.on("newUser", (pseudo) {
        debugPrint("New user $pseudo");
      });

      // On check si le user se déconnecte
      socket.on("quitUser", (message) {
        debugPrint("user quit");
      });
    });

    socket.onConnectError((err) => debugPrint("$err"));
    socket.onError((err) => debugPrint("$err"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.back_hand_rounded,
          color: Colors.white,
        ),
        elevation: 0.5,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        leadingWidth: 20,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Chats",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Container(
                    margin: const EdgeInsets.only(
                      left: 10,
                    ),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "0", //nombre de messages
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    )),
              ],
            ), //nom de la personne
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.black,
              )),
          const SizedBox(width: 5),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              )),
          const SizedBox(width: 10),
          Material(
            elevation: 2.0,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: Ink.image(
              image: const AssetImage("img/pp.png"),
              //id.photoprofil
              fit: BoxFit.contain,
              width: 25,
              height: 25,
              child: InkWell(
                onTap: () {},
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(bottom: 55),
          itemCount: mesConvData.length, //nombre de messages dans la bd
          itemBuilder: (context, index) {
            InChatModel model = mesConvData[index];
            return InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return MyMessagePage(
                      lechoix: model, socket: socket, setMsg: setMessage);
                }));
              },
              child: HomeContent(
                photoprofile: model.avatarUrl,
                nom: model.nom,
                lastmessage: model.lastMessage().message,
                heurelastmessage: model.lastMessage().datetime,
                enLigne: model.isOnLigne,
              ),
            );
          }),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //margin: EdgeInsets.only(left: 0,top: 22,right: 60,bottom: 0),
            width: MediaQuery.of(context).size.width / 2,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(
                    0.0,
                    10.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: -6.0,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, top: 5, right: 5, bottom: 5),
                  width: MediaQuery.of(context).size.width / 4.5,
                  height: 40,
                  decoration: BoxDecoration(
                    color: chat ? Colors.white : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          call = false;
                          chat = true;
                        });
                      },
                      child: Text(
                        "chats",
                        style: TextStyle(
                            color: chat ? Colors.greenAccent : Colors.black,
                            fontSize: 18),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, top: 5, right: 5, bottom: 5),
                  width: MediaQuery.of(context).size.width / 4.5,
                  height: 40,
                  decoration: BoxDecoration(
                    color: call ? Colors.white : Colors.greenAccent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          call = true;
                          chat = false;
                        });
                      },
                      child: Text(
                        "calls",
                        style: TextStyle(
                            color: call ? Colors.greenAccent : Colors.black,
                            fontSize: 18),
                      )),
                )
              ],
            ),
          ),
          Container(
              margin:
                  const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(
                      0.0,
                      10.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: -6.0,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ListContacts(socket: socket, setMsg: setMessage);
                  }));
                },
                icon: const Icon(
                  Icons.message,
                  color: Colors.white,
                  size: 30,
                ),
              )),
        ],
      ),
    );
  }

  bool call = false;
  bool chat = true;
}
