import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:myline_car/model/result.dart';

class FirebaseAuthentication {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<Result<String>> sendOTP(int phone) async {
    final Completer<Result<String>> completer = Completer<Result<String>>();
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+91$phone',
        verificationCompleted: (PhoneAuthCredential credential) {},
        codeAutoRetrievalTimeout: (String verificationId) {},
        verificationFailed: (FirebaseAuthException e) {
          completer.complete(Result.error("VerificationFailed : ${e.message}"));
        },
        codeSent: (String verifyId, int? resendToken) {
          completer.complete(Result.success(verifyId));
        },
      );
      return completer.future;
      // return Result.success(verificationId);
    } catch (e) {
      return Result.error('$e');
    }
  }

  static Future<Result<UserCredential>> authenticate(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential = await auth.signInWithCredential(credential);
      return Result.success(userCredential);
    } catch (e) {
      return Result.error('$e');
    }
  }
}
