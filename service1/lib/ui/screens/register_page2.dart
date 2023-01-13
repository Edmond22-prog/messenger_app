import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_authentication/controllers/authentication/register_controller.dart';
import 'package:phone_authentication/models/user.dart';
import 'package:phone_authentication/ui/screens/home_page.dart';

class RegisterPage2 extends StatelessWidget {
  final String phoneNumber;

  RegisterPage2({Key? key, required this.phoneNumber}) : super(key: key);

  // Value who will contain the pseudo
  final _controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(children: [
          Container(
            margin: EdgeInsets.only(top: height / 10),
            child: Center(
              child: Text('User Registration',
                  style: TextStyle(
                    color: Colors.blue,
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
                    pseudo: _controller.pseudo.text.trim(), phone: phoneNumber);
                RegisterController.instance.createUser(user);
              }
            },
            child: const Text('Create account'),
          ),
        ),
      ]),
    );
  }
}
