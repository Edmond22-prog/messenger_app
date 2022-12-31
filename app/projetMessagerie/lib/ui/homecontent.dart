import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  final String photoprofile;
  final String nom;
  final String lastmessage;
  final String heurelastmessage;


  HomeContent({
    required this.photoprofile,
    required this.nom,
    required this.lastmessage,
    required this.heurelastmessage,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: provenance? EdgeInsets.only(left: 60,top: 22,right: 0,bottom: 10):EdgeInsets.only(left: 0,top: 22,right: 60,bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Material(
                      elevation: 2.0,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: Ink.image(
                        image: AssetImage(photoprofile),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        child: InkWell(
                          onTap: (){ },
                        ),
                      ),
                    )
                ),
                alignment: Alignment.center,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(nom,
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
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(lastmessage,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black45
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          textAlign: TextAlign.center,
                        )
                    ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 7),
                        Text(heurelastmessage,style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ],
                ),
                alignment: Alignment.bottomLeft,
              ),
              Text("")
            ],
          )

        ],
      ),
    );
  }
}