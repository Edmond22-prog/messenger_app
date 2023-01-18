import 'package:get/get.dart';
import 'package:projetmessagerie/ui/pages/auth/register_page2.dart';

import '../../repositories/authentication_repository.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();

  void verifyOTP(String phoneNo, String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    //var isVerified = true;
    isVerified ? Get.to(() => RegisterPage2(
      phoneNumber: phoneNo)) : Get.back();
  }
}