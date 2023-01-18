import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/authentication/register_controller.dart';
import '../../../models/user.dart';

class RegisterPage2 extends StatefulWidget {
  final String phoneNumber;

  const RegisterPage2({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final _controller = Get.put(RegisterController());

  // Shared Preferences instance
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _saveCurrentUser(User user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('pseudo', user.pseudo);
    prefs.setString('phone', user.phone);
    debugPrint("User saved in Shared Preferences");

    // Save the state of the app to tell that user is already registered
    prefs.setBool('welcome', true);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: height / 10),
              child: Center(
                child: Text('User Registration',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: width / 15,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: width / 10, right: width / 10, left: width / 10),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Pseudo',
                  hintText: 'Enter your pseudo',
                  prefixIcon: Icon(Icons.person),
                ),
                keyboardType: TextInputType.name,
                controller: _controller.pseudo,
                onChanged: (value) {
                  debugPrint(value);
                },
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.all(width / 10),
            width: double.infinity,
            height: width / 13,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                if (_controller.pseudo.text.isNotEmpty) {
                  final user = User(
                      pseudo: _controller.pseudo.text.trim(),
                      phone: widget.phoneNumber);
                  _saveCurrentUser(user);
                  RegisterController.instance.createUser(user);
                }
              },
              child: const Text('Create account'),
            ),
          ),
        ],
      ),
    );
  }
}
