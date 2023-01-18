import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:projetmessagerie/ui/pages/auth/home_page.dart';

import '../../models/user.dart';
import '../../repositories/authentication_repository.dart';
import '../../repositories/user_repository.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // TextField Controllers to get data from TextFields
  final pseudo = TextEditingController();
  final phoneNumber = TextEditingController();

  // The user repository
  final _userRepository = Get.put(UserRepository());

  // Register the user to the Firestore Database
  Future<void> createUser(User user) async {
    await _userRepository.createUser(user);
    Get.offAll(const HomePage());
  }

  // Get phone number from user and pass it to Auth Repository for Firebase Authentication
  void phoneAuthentication(String phoneNo) {
    phoneNo = "+237$phoneNo";
    AuthenticationRepository.instance.phoneAuthentication(phoneNo);
  }
}
