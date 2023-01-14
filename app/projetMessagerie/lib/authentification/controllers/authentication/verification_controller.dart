import 'package:get/get.dart';
import 'package:projetmessagerie/authentification/repositories/authentication_repository.dart';
import 'package:projetmessagerie/authentification/ui/screens/register_page2.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();

  void verifyOTP(String phoneNo, String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    //var isVerified = true;
    isVerified ? Get.to(() => RegisterPage2(
      phoneNumber: phoneNo)) : Get.back();
  }
}