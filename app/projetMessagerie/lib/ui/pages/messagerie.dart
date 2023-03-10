import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projetmessagerie/ui/pages/home.dart';
import 'package:projetmessagerie/ui/pages/messagecontent.dart';
import 'package:projetmessagerie/ui/src/widgets/record_button.dart';
import 'package:record/record.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import '../../models/new_message_param.dart';
import '../../models/socket_param.dart';

class MyMessagePage extends StatefulWidget {
  const MyMessagePage(
      {super.key,
      required this.lechoix,
      required this.socket,
      required this.setMsg});

  final InChatModel lechoix;
  final IO.Socket socket;
  final Function setMsg;

  @override
  State<MyMessagePage> createState() => _MessagePageState();
}

///////////////////////////////
class InChatModel {
  final String avatarUrl;
  final String nom;
  final List<MessageModel> listmessage;

  final bool isOnLigne;

  InChatModel(
      {required this.avatarUrl,
      required this.nom,
      required this.listmessage,
      required this.isOnLigne});

  void add(String date, String message) {
    listmessage.add(MessageModel(
        datetime: date, message: message, EnvMessage: true, etat: false));
  }

  MessageModel lastMessage() {
    return listmessage.last;
  }
}

class MessageModel {
  final String datetime;
  final String message;
  final bool EnvMessage; //false = je recois   true = j'envoie le message
  final bool etat; //false = message envoiyé  true = message reçu

  MessageModel(
      {required this.datetime,
      required this.message,
      required this.EnvMessage,
      required this.etat});
}

class _MessagePageState extends State<MyMessagePage>
    with SingleTickerProviderStateMixin {
  late InChatModel lechoisie;
/*
  void verifChoisi(InChatModel lechois){
    lechoisie=lechois;
   /* for(int i=0;i<mesConvData.length;i++) {
      if (widget.id == mesConvData[i].nom) {
        lechoisie = mesConvData[i];
      }
    }*/
  }
*/

  DateTime? startTime;
  Timer? timer;
  String recordDuration = "00:00";
  //late Record record;
  Record? record;

  bool isLocked = false;
  bool showLottie = false;

  String message = "";
  String heureEnvoie = "";
  String dateEnvoie = "";

  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    voiceState = true;

    lechoisie = widget.lechoix;

    widget.socket.on("whisper", (content) {
      debugPrint("je reçois ici");
      var chatReceived = NewMessageParam.fromJson(Map.from(content));
      var date = DateTime.now();
      debugPrint(
          "j'ai reçu le msg de ${chatReceived.sender} qui est ${chatReceived.message}");
      String formattedTime = DateFormat.Hm().format(date);
      setState(() {
        lechoisie = widget.lechoix;
      });
      //type = "sender" équivaut au pseudo qui envoi le msg  à user et type="receiver"
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void callEmoji() {
    debugPrint('Emoji Icon Pressed...');
  }

  void callAttachFile() {
    debugPrint('Attach File Icon Pressed...');
  }

  void callCamera() {
    debugPrint('Camera Icon Pressed...');
  }

  void callVoice() {
    debugPrint('Voice Icon Pressed...');
  }

  void sendMessage() {
    setState(() {
      final setMessage = widget.setMsg;
      setMessage(lechoisie.nom, message, "sender");
      SocketParam newMessage =
          SocketParam(message: message, receiver: lechoisie.nom);
      widget.socket.emit("newMessage", jsonEncode(newMessage));
      // lechoisie=widget.lechoix;
    });
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
        });
  }

  bool voiceState = true;
  Widget voiceIcon() {
    return RecordButton(
        controller:
            controller); /*const Icon(
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

  Widget modeText() {
    return Row(
      children: [
        moodIcon(),
        Expanded(
          child: TextField(
            onChanged: (val) {
              setState(() {
                if (val == "") {
                  voiceState = true;
                } else {
                  voiceState = false;
                }
                message = val;
              });
            },
            decoration: const InputDecoration(
                hintText: "Message",
                hintStyle: TextStyle(color: Colors.black),
                border: InputBorder.none),
            maxLines: 5,
            minLines: 1,
          ),
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
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return const HomeConvPage(
                pseudo: "",
                number: "",
              );
            }));
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        leadingWidth: 20,
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: Ink.image(
                image: AssetImage(lechoisie.avatarUrl), //id.photoprofil
                fit: BoxFit.cover,
                width: 35,
                height: 35,
                child: InkWell(
                  onTap: () {},
                ),
              ),
            ),
            const Text("  "),
            Column(
              children: [
                Text(
                  lechoisie.nom[0].toUpperCase() + lechoisie.nom.substring(1),
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                lechoisie.isOnLigne
                    ? const Text(
                        "en ligne",
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      )
                    : const Text("")
              ],
            ), //nom de la personne
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call,
                color: Colors.greenAccent,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.videocam,
                color: Colors.blueAccent,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ))
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.only(bottom: 55),
          itemCount:
              lechoisie.listmessage.length, //nombre de messages dans la bd
          itemBuilder: (context, index) {
            return InkWell(
                onLongPress: () {
                  //selection
                },
                child: MessageContent(
                  contenu: lechoisie.listmessage[index].message,
                  heure: lechoisie.listmessage[index].datetime,
                  provenance: lechoisie.listmessage[index].EnvMessage,
                  etat: lechoisie.listmessage[index].etat,
                ));
          }),
      floatingActionButton: BottomAppBar(
        child: Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            color: Colors.green.withOpacity(0.1),
            child: Row(children: [
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
                  child: voiceState ? voiceIcon() : voiceIcontexte(),
                  onTap: () {
                    if (!voiceState) {
                      sendMessage();
                    }
                  },
                ),
              )
            ])),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> dialog() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35.0),
              ),
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Icon(Icons.file_open, size: 50),
                      Icon(Icons.camera, size: 50),
                      Icon(Icons.filter, size: 50)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
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

      // final imageFinal = File(image.path);
      setState(() {
        //function d'envoie de limage
        debugPrint("image envoiyé");
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to pick image $e");
    }
  }
}
