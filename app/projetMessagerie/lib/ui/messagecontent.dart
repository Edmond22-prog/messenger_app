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
    return Container(
      margin: provenance? EdgeInsets.only(left: 60,top: 22,right: 0,bottom: 10):EdgeInsets.only(left: 0,top: 22,right: 60,bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
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
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  contenu,
                  style: TextStyle(
                      fontSize: 19,
                      color: Colors.black
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                )
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
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
    );
  }
}