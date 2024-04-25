import 'package:flutter/material.dart';
import 'package:myline_car/model/user.dart';
import 'package:myline_car/utils/colors.dart';
import 'package:myline_car/view_model/user_provider.dart';
import 'package:provider/provider.dart';

import '../splash/splash_screen.dart';

class LoginNameScreen extends StatelessWidget {
  final String phone;

  LoginNameScreen({super.key, required this.phone});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Let's get to know each other! What's your name?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 15),
                TextField(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  controller: nameController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: colors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    // Show loading dialog
                    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));

                    User user = User(name: nameController.text, phone: phone);
                    await Provider.of<UserProvider>(context, listen: false).saveUser(user);
                    // Close Dialog
                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
