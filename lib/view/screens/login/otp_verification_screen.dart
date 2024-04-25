import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myline_car/model/result.dart';
import 'package:myline_car/utils/colors.dart';
import 'package:myline_car/view_model/firebase_auth_provider.dart';
import 'package:myline_car/view_model/user_provider.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatelessWidget {
  final int phone;
  final String verificationId;

  const OtpVerificationScreen({super.key, required this.phone, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify")),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Verification code',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'roboto'),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Please enter the code sent to your mobile',
                style: TextStyle(fontSize: 15, fontFamily: 'roboto'),
              ),
            ),
            const SizedBox(height: 55),
            OtpTextField(
              numberOfFields: 6,
              showFieldAsBox: true,
              focusedBorderColor: colors.primaryColor,
              onSubmit: (otp) {
                authenticate(context, otp);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: colors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () async {},
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void authenticate(BuildContext context, String otp) async {
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
    var result = await Provider.of<FirebaseAuthProvider>(context, listen: false).authenticate(verificationId, otp);
    if (result.status == Status.success) {
      Provider.of<UserProvider>(context, listen: false).login(context, phone);
    } else {
      Fluttertoast.showToast(msg: 'Failed : ${result.message}');
    }
    Navigator.pop(context);
  }
}
