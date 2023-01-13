import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  final String photoprofile;
  final String nom;
  final String lastmessage;
  final String heurelastmessage;
  final bool enLigne;


  HomeContent({
    required this.photoprofile,
    required this.nom,
    required this.lastmessage,
    required this.heurelastmessage,
    required this.enLigne,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Material(
                      elevation: 2.0,
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: Ink.image(
                        image: AssetImage(photoprofile),
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
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
                  Container(
                    width: 200,
                    //margin: EdgeInsets.only(right: 70),
                    child: Align(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(nom[0].toUpperCase() + nom.substring(1),
                            style: TextStyle(
                                fontSize: 19,
                                color: Colors.black
                            ),
                            textAlign: TextAlign.start,
                          )
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  Container(
                    width: 200,
                    child: Align(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 100,
                            child: Text(lastmessage,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black45
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.start,
                            ),
                          )
                      ),
                      alignment: Alignment.topLeft,
                    ),
                  )
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
              enLigne?Text("en ligne    ",style: TextStyle(color: Colors.greenAccent),):Text("en ligne    ",style: TextStyle(color: Colors.white))
            ],
          ),

        ],
      ),
    );
  }
}