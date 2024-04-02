import 'package:flutter/material.dart';
import 'package:myline_car/view_model/cars_provider.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../view_model/user_provider.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(size: 150),
      ),
    );
  }

  void init() async {
    User? user = await Provider.of<UserProvider>(context, listen: false).loadUser();
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (user != null) {
        Provider.of<CarsProvider>(context, listen: false).loadCars(user.phone);
        Provider.of<UserProvider>(context, listen: false).loadAllUsers();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
      }
    });
  }
}
