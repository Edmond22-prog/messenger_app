import 'package:flutter/material.dart';

class MessageContent extends StatelessWidget {
  final String contenu;
  final String heure;
  final bool provenance;
  final bool etat;


  MessageContent({
    required this.contenu,
    required this.heure,
    required this.provenance,
    required this.etat,
  });
  @override
  Widget build(BuildContext context) {


    double cmptLigne(){
      double nbLigne;
      int ligne=contenu.length;
      double n=ligne.toDouble();
      nbLigne=n/20;
      return nbLigne;
    }
    double tailleBox(){
      double taille = MediaQuery.of(context).size.width;
      int tailleText=contenu.length;
      if(tailleText>20){
        taille=tailleText.toDouble() ;
      }
      return taille;
    }



    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: provenance? EdgeInsets.only(left: 60,top: 22,right: 5,bottom: 0):EdgeInsets.only(left: 5,top: 22,right: 60,bottom: 0),
          width: MediaQuery.of(context).size.width,
          //height: 40,
          decoration: BoxDecoration(
            color: provenance?Colors.greenAccent.shade100:Colors.white,
            borderRadius:provenance? BorderRadius.only(topLeft:Radius.circular(30),topRight:Radius.circular(30),bottomLeft:Radius.circular(30),):BorderRadius.only(topLeft:Radius.circular(30),topRight:Radius.circular(30),bottomRight:Radius.circular(30),),
            border: provenance?Border.all(color: Colors.greenAccent.shade100):Border.all(color: Colors.black),
            boxShadow: [
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                    child:SizedBox(
                      width: MediaQuery.of(context).size.width/1.9,
                      child:  Text(
                        contenu,
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black
                        ),
                      ),
                    )
                ),
                alignment: Alignment.center,
              ),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      margin: EdgeInsets.all(5),
                      /*decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),*/
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 7),
                          Text(heure,style: TextStyle(color: Colors.black),),
                          !provenance? Text(""):etat? Icon(Icons.check,color: Colors.blue,):Icon(Icons.check,color: Colors.black45,),


                        ],
                      ),
                    ),
                  ],
                ),
                alignment: Alignment.bottomLeft,
              ),
            ],
          ),
        )
      ],
    );
  }
}