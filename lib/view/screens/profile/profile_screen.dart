import 'package:flutter/material.dart';
import 'package:myline_car/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../view_model/user_provider.dart';
import '../splash/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: [
          // User profile photo
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Center(
              child: Stack(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 130,
                    color: Colors.grey,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User details
          _profileTile(user!.name, 'Name'),
          _profileTile('+91 ${user.phone}', 'Phone number'),

          const Spacer(),
          // Logout button
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: SizedBox(
              width: 140,
              height: 45,
              child: TextButton(
                style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () {
                  logoutDialog(context);
                },
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: colors.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _profileTile(String text, String subText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subText,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(
            thickness: 1,
            height: 10,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to logout'),
        surfaceTintColor: Colors.white,
        actions: [
          TextButton(
              style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), backgroundColor: colors.primaryColor, foregroundColor: Colors.white),
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false).removeUser();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (Route<dynamic> route) => false);
              },
              child: const Text('Logout'))
        ],
      ),
    );
  }
}
