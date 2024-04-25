import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myline_car/utils/colors.dart';
import 'package:myline_car/view/screens/login/otp_verification_screen.dart';
import 'package:provider/provider.dart';

import '../../../model/result.dart';
import '../../../view_model/firebase_auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: welcomeSection()),
          Expanded(child: LoginSection()),
        ],
      ),
    );
  }

  Widget welcomeSection() {
    return Container(
      color: colors.primaryColor,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to MyLine Car',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, fontFamily: 'roboto', color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            'Please sign in to continue',
            style: TextStyle(fontSize: 15, fontFamily: 'roboto', color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class LoginSection extends StatelessWidget {
  LoginSection({Key? key}) : super(key: key);

  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Login TextField
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: colors.primaryColor.withOpacity(.4), blurRadius: 20, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!))),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      prefixText: "+91 ",
                      prefixStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black),
                      hintText: 'Phone number',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Login button
          SizedBox(
            width: 180,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: colors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () async {
                int? phone = int.tryParse(phoneController.text);
                if (phone != null && phoneController.text.length == 10) {
                  showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
                  var result = await Provider.of<FirebaseAuthProvider>(context, listen: false).sendOTP(phone);
                  if (result.status == Status.success) {
                    String verificationId = result.data!;
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => OtpVerificationScreen(phone: phone, verificationId: verificationId)));
                  } else {
                    Fluttertoast.showToast(msg: 'Failed : ${result.message}');
                  }
                } else {
                  Fluttertoast.showToast(msg: 'Failed to enter phone number. Please try again', backgroundColor: Colors.red);
                }
              },
              child: const Text(
                'Sign in',
                style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
