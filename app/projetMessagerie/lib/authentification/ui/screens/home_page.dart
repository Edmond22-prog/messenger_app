import 'package:flutter/material.dart';
import 'package:projetmessagerie/ui/home.dart';

class HomePage extends StatelessWidget {
  final String pseudo;
  final String phoneNumber;

  const HomePage({super.key, required this.pseudo, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Pseudo:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(pseudo, style: const TextStyle(fontSize: 20)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Phone Number:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(phoneNumber, style: const TextStyle(fontSize: 20)),
            ],
          ),
          Container(
              margin: const EdgeInsets.only(top: 50),
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return HomeConvPage(title: 'Message Me');
                      }));
                },
                child: const Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ),
        ]),
      ),
    );
  }
}
