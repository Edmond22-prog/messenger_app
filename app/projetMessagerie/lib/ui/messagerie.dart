

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projetmessagerie/ui/messagecontent.dart';
import 'package:projetmessagerie/ui/messagerie.dart';
import 'package:projetmessagerie/ui/src/globals.dart';
import 'package:projetmessagerie/ui/src/widgets/record_button.dart';
import 'package:record/record.dart';

class MyMessagePage extends StatefulWidget {
  const MyMessagePage({super.key, required this.id});

  final String id;

  @override
  State<MyMessagePage> createState() => _MessagePageState();

}
///////////////////////////////
class InChatModel{
  final String avatarUrl;
  final String nom;
  final List<MessageModel> listmessage;

  InChatModel({required this.avatarUrl, required this.nom, required this.listmessage});

  void add(String date,String message){
    listmessage.add(new MessageModel(datetime:date,message:message,EnvMessage:true));
  }
}
class MessageModel{
  final String datetime;
  final String message;
  final bool EnvMessage;//false = je recois   true = j'envoie le message

  MessageModel({required this.datetime, required this.message, required this.EnvMessage});
}

class _MessagePageState extends State<MyMessagePage> with SingleTickerProviderStateMixin{


  static final List<InChatModel> mesConvData = [
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc",
        listmessage: [
          MessageModel(
              datetime: "20:30",
              message: "bonjour",
              EnvMessage: false
          ),
          MessageModel(
              datetime: "20:31",
              message: "bonjour",
              EnvMessage: true
          ),
          MessageModel(
              datetime: "20:40",
              message: "cava?",
              EnvMessage: false
          ),
        ]
    ),
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc1",
        listmessage: [
          MessageModel(
              datetime: "20:30",
              message: "bonjour",
              EnvMessage: true
          ),
          MessageModel(
              datetime: "20:38",
              message: "yo",
              EnvMessage: false
          ),
        ]
    ),
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "luc",
        listmessage: [
          MessageModel(
              datetime: "20:35",
              message: "bonjour",
              EnvMessage: false
          ),
        ]
    ),
    InChatModel(
        avatarUrl: "img/pp.png",
        nom: "marc3",
        listmessage: [
          MessageModel(
              datetime: "20:30",
              message: "bonjour",
              EnvMessage: true
          ),
        ]
    ),

  ];


  late InChatModel lechoisie;

  void verifChoisi(){
    for(int i=0;i<mesConvData.length;i++) {
      if (widget.id == mesConvData[i].nom) {
        lechoisie = mesConvData[i];
      }
    }
  }











  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  //late Record record;
  Record? record;

  bool isLocked = false;
  bool showLottie = false;



  String message="";
  String heureEnvoie="";
  String dateEnvoie="";

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );


    voiceState=true;


    verifChoisi();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  void callEmoji() {
    print('Emoji Icon Pressed...');
  }

  void callAttachFile() {
    print('Attach File Icon Pressed...');
  }

  void callCamera() {
    print('Camera Icon Pressed...');
  }

  void callVoice() {
    print('Voice Icon Pressed...');
  }
  void sendMessage() {

    DateTime sendDate = new DateTime.now();
    dateEnvoie = sendDate.toString();
    int h=sendDate.hour;
    int m=sendDate.minute;

    heureEnvoie = h.toString()+":"+m.toString();

    lechoisie.add(heureEnvoie, message);


    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> super.widget));
    print('Message send...');
  }




  Widget moodIcon() {
    return IconButton(
        icon: const Icon(
          Icons.mood,
          color: Colors.black,
        ),
        onPressed: () => callEmoji());
  }

  Widget attachFile() {
    return IconButton(
      icon: const Icon(Icons.attachment_sharp, color: Colors.black),
      onPressed: () {
        setState(() {
          dialog();
          callAttachFile();
        });
      },
    );
  }

  Widget camera() {
    return IconButton(
        icon: const Icon(Icons.photo_camera, color: Colors.black),
        onPressed: () {
          pickImage(ImageSource.camera);
          callCamera();
        }
    );
  }

  bool voiceState =true;
  Widget voiceIcon() {
    return RecordButton(controller: controller);/*const Icon(
  Icons.keyboard_voice,
  color: Colors.black,
  );*/
  }
  Widget voiceIcontexte() {
    return const Icon(
      Icons.send,
      color: Colors.black,
    );
  }

  Widget modeText(){
    return Row(
      children: [
        moodIcon(),
        Expanded(
            child: Container(
              child:TextField(
                onChanged: (val){setState(() {
                  if(val==""){
                    voiceState=true;
                  }else{
                    voiceState=false;
                  }
                  message=val;
                });
                },
                decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none
                ),
                maxLines: 5,
                minLines: 1,
              ),
            )
        ),
        attachFile(),
        camera(),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                elevation: 2.0,
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: Ink.image(
                  image: AssetImage(lechoisie.avatarUrl),//id.photoprofil
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  child: InkWell(
                    onTap: (){ },
                  ),
                ),
              ),
              Text(lechoisie.nom),//nom de la personne
              Text("")
            ],
          )
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(bottom: 55),
          itemCount: lechoisie.listmessage.length,//nombre de messages dans la bd
          itemBuilder: (context,index){
            return InkWell(
                onLongPress: (){
                  //selection
                },
                child: MessageContent(
                  contenu: lechoisie.listmessage[index].message,
                  heure: lechoisie.listmessage[index].datetime,
                  provenance: lechoisie.listmessage[index].EnvMessage,
                )
            );

          }),



      floatingActionButton: BottomAppBar(
        child: Container(
            color: Colors.green.withOpacity(0.1),
            child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 2),
                              blurRadius: 7,
                              color: Colors.grey)
                        ],
                      ),
                      child: modeText(),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: const BoxDecoration(
                        color: Color(0xFF00BFA5), shape: BoxShape.circle),
                    child: InkWell(
                      child: voiceState ? voiceIcon():voiceIcontexte(),

                      onTap: (){
                        if(!voiceState){
                          sendMessage();
                        }
                      },
                    ),
                  )
                ]
            )
        ),
      ),floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }





  Future<Null> dialog()async{
    return showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext context){
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
              ),
              width: MediaQuery.of(context).size.width/1.1,
              height: MediaQuery.of(context).size.height/3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon( Icons.file_open, size: 50),
                      Icon(Icons.camera, size: 50),
                      Icon(Icons.filter, size: 50)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.music_note_outlined, size: 50),
                      Icon(Icons.location_on_outlined, size: 50),
                      Icon(Icons.contacts, size: 50)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future pickImage(ImageSource imageSource) async {
    try {

      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      final imageFinal = File(image.path);
      setState(() {
        //function d'envoie de limage
        print("image envoiyé");
      });
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }
  }



}




