import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:projetmessagerie/authentification/controllers/authentication/verification_controller.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;

  const VerificationPage(
      {super.key, required this.phoneNumber});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var otp = "";

    // Variables for pin theme
    const focusedBorderColor = Colors.amber;
    var fillColor = Colors.green.shade200;

    final defaultPinTheme = PinTheme(
        width: width / 7,
        height: height / 10,
        textStyle: TextStyle(
          fontSize: width / 15,
          color: Colors.black,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: Colors.greenAccent),
        ));

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: height / 10, bottom: height / 20),
            child: Center(
              child: Text(
                'Verify +237-${widget.phoneNumber}',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: width / 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Directionality(
            // Specify direction if desired
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 6,
              controller: _pinController,
              focusNode: _focusNode,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                debugPrint('onCompleted: $pin');
                setState(() {
                  otp = pin;
                });
                Get.put(VerificationController())
                    .verifyOTP(widget.phoneNumber, otp);
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: Colors.greenAccent,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.greenAccent),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: fillColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: Colors.redAccent),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(width / 10),
            width: width / 5,
            height: width / 13,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Get.put(VerificationController())
                    .verifyOTP(widget.phoneNumber, otp);
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}
