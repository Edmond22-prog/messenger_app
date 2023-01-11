import 'package:flutter/material.dart';
import 'package:projetmessagerie/ui/home.dart';
import 'package:projetmessagerie/ui/messagerie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messagerie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Message Me'),

    );
  }
}
