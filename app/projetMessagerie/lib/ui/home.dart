
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
class ChatModel{
  final String avatarUrl;
  final String nom;
  final String datetime;
  final String message;

  ChatModel({required this.avatarUrl, required this.nom, required this.datetime, required this.message});
}


class _MyHomePageState extends State<HomePage> {


  static final List<ChatModel> maConvData = [
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc",
        datetime: "20:18",
        message: "bonjour"
    ),
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc1",
        datetime: "20:20",
        message: "comment va tu ?"
    ),
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "luc",
        datetime: "20:19",
        message: "helloooooooo"
    ),
    ChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc3",
        datetime: "20:50",
        message: "hum......"
    ),

  ];











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: maConvData.length,//nombre de messages dans la bd
          itemBuilder: (context,index){
            ChatModel _model = maConvData[index];
            return InkWell(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                  return MyMessagePage(id: _model.nom,);
                }));

              },
                child: HomeContent(photoprofile: _model.avatarUrl, nom: _model.nom, lastmessage: _model.message, heurelastmessage: _model.datetime,),
            );

          }),
    );
  }



}




