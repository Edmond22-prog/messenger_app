import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_authentication/controllers/authentication/register_controller.dart';
import 'package:phone_authentication/ui/screens/verification_page.dart';


class RegisterPage1 extends StatelessWidget {
  RegisterPage1({Key? key}) : super(key: key);
  
  // Value who will contain the phone number
  final _controller = Get.put(RegisterController());

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
                child: Text('Phone Verification',
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
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icon(Icons.phone),
                  prefix: Text('+237 '),
                ),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                controller: _controller.phoneNumber,
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
                // Do the phone authentication
                Get.put(RegisterController())
                    .phoneAuthentication(_controller.phoneNumber.text.trim());
                // Navigate to the verification page
                Get.to(() => VerificationPage(
                  phoneNumber: _controller.phoneNumber.text));
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}
