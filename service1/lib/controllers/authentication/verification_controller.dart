import 'package:get/get.dart';
import 'package:phone_authentication/repositories/authentication_repository.dart';
import 'package:phone_authentication/ui/screens/register_page2.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();

  void verifyOTP(String phoneNo, String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.to(() => RegisterPage2(
      phoneNumber: phoneNo)) : Get.back();
  }
}