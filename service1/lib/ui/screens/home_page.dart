import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userID;
  final String phoneNumber;

  const HomePage({super.key, required this.userID, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('User ID:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(userID, style: const TextStyle(fontSize: 20)),
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
            child: const Text(
              'Connected',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ),
        ]),
      ),
    );
  }
}
