import 'package:get/get.dart';
import 'package:phone_authentication/repositories/authentication_repository.dart';
import 'package:phone_authentication/ui/screens/home_page.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();

  void verifyOTP(String userID, String phoneNo, String otp) async {
    var isVerified = await AuthenticationRepository.instance.verifyOTP(otp);
    isVerified ? Get.offAll(HomePage(userID: userID, phoneNumber: phoneNo)) : Get.back();
  }
}