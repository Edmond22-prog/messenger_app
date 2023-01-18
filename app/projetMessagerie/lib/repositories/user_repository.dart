import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(User user) async {
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar("Succes", "Your account has been created.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      debugPrint("The Error: ${error.toString()}");
    });
  }

  // This part is for fetching data from firestore
  Future<User> getUserDataByNumber(String phone) async {
    final snapshot = await _db.collection("Users").where("Phone", isEqualTo: phone).get();
    final userData = snapshot.docs.map((e) => User.fromSnapshot(e)).single;

    return userData;
  }

  Future<List<User>> getUsers() async {
    final snapshot = await _db.collection("Users").get();
    final usersData = snapshot.docs.map((e) => User.fromSnapshot(e)).toList();
    
    return usersData;
  }
}
