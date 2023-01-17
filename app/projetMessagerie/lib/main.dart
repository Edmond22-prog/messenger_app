import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:projetmessagerie/firebase_options.dart';
import 'package:projetmessagerie/repositories/authentication_repository.dart';
import 'package:projetmessagerie/ui/pages/auth/register_page1.dart';
import 'package:projetmessagerie/ui/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
      ),
      debugShowCheckedModeBanner: false,
      transitionDuration: const Duration(milliseconds: 500),
      home: RegisterPage1(), // firstTime? RegisterPage1(): const HomeConvPage(title: 'Message Me'),
    );
  }
}
