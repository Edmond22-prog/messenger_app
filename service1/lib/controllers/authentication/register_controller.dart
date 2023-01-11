import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:phone_authentication/repositories/authentication_repository.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // TextField Controllers to get data from TextFields
  final userID = TextEditingController();
  final phoneNumber = TextEditingController();

  // Get phone number from user and pass it to Auth Repository for Firebase Authentication
  void phoneAuthentication(String phoneNo) {
    phoneNo = "+237$phoneNo";
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }
}
