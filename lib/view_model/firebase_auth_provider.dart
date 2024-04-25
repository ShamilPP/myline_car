import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/service/firebase_auth.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  Future<Result<String>> sendOTP(int phone) async {
    var result = await FirebaseAuthentication.sendOTP(phone);
    return result;
  }

  Future<Result<UserCredential>> authenticate(String verificationId, String otp) async {
    var result = await FirebaseAuthentication.authenticate(verificationId, otp);
    return result;
  }
}
