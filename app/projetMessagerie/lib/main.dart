import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:projetmessagerie/authentification/firebase_options.dart';
import 'package:projetmessagerie/authentification/repositories/authentication_repository.dart';
import 'package:projetmessagerie/authentification/ui/screens/register_page1.dart';
import 'package:projetmessagerie/authentification/ui/screens/register_page2.dart';
import 'package:projetmessagerie/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
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
        primarySwatch: Colors.green,
      ),debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Message Me'),

    );
  }
}*/


Future<void> main() async {

  // Initialization for Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      themeMode: ThemeMode.system,
      defaultTransition: Transition.leftToRightWithFade,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),debugShowCheckedModeBanner: false,
      transitionDuration: const Duration(milliseconds: 500),
      home: new FutureBuilder<SharedPreferences>(
    future: SharedPreferences.getInstance(),
    builder:
    (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
    switch (snapshot.connectionState) {
    case ConnectionState.none:
    case ConnectionState.waiting:
    //return new RegisterPage1();
    default:
    if (snapshot.data?.getBool("welcome") != null) {
    return new HomeConvPage(title: 'Message Me');
    } else {
      snapshot.data?.setBool('welcome', true);
      return new RegisterPage1();
    }
    }
    },
    ),// firstTime? RegisterPage1(): const HomeConvPage(title: 'Message Me'),
    );
  }
}
