import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  var verificationId = ''.obs;

  // Future for phone authentication
  // This is the code who will send the OTP code to phone number if the number 
  //is correct
  Future<void> phoneAuthentication(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credentials) async {
        await _auth.signInWithCredential(credentials);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          // Get.snackbar('Error', 'The provided phone number is not valid.');
          debugPrint('The provided phone number is not valid.');
        } else {
          // Get.snackbar('Error', 'Something went wrong, please try again later.');
          debugPrint('Something went wrong, please try again later.');
          debugPrint('Error code: ${e.code}');
        }
      },
    );
  }

  // Future for code verification
  // This code verify if the otp wrote by the user is the sended otp
  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
