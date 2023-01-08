
import 'package:flutter/material.dart';
import 'package:projetmessagerie/ui/homecontent.dart';
import 'package:projetmessagerie/ui/messagerie.dart';

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

class _MyHomePageState extends State<HomePage> {


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

  static final List<InChatModel> mesConvData = [
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc",
        listmessage: [
          MessageModel(
              datetime: "20:30",
              message: "bonjour",
              EnvMessage: false,
              etat: true
          ),
          MessageModel(
              datetime: "20:31",
              message: "bonjour",
              EnvMessage: true,
              etat: true
          ),
          MessageModel(
              datetime: "20:40",
              message: "cava?",
              EnvMessage: false,
              etat: true
          ),
        ], isOnLigne: true
    ),
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "jean",
        listmessage: [
          MessageModel(
              datetime: "20:30",
              message: "bonjour",
              EnvMessage: true,
              etat: true
          ),
          MessageModel(
              datetime: "20:38",
              message: "yo",
              EnvMessage: false,
              etat: true
          ),
        ], isOnLigne: true
    ),
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "luc",
        listmessage: [
          MessageModel(
              datetime: "20:35",
              message: "bonjour",
              EnvMessage: false,
              etat: true
          ),
        ], isOnLigne: false
    ),
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc3",
        listmessage: [
          MessageModel(
              datetime: "20:30",
              message: "bonjour",
              EnvMessage: true,
              etat: false
          ),
        ], isOnLigne: true
    ),

  ];






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: mesConvData.length,//nombre de messages dans la bd
          itemBuilder: (context,index){
            InChatModel _model = mesConvData[index];
            return InkWell(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return MyMessagePage( lechoix: _model);
                }));

              },
                child: HomeContent(photoprofile: _model.avatarUrl, nom: _model.nom, lastmessage: _model.lastMessage().message, heurelastmessage: _model.lastMessage().datetime, enLigne: _model.isOnLigne,),
            );

          }),
    );
  }



}




