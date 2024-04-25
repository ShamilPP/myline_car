import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myline_car/utils/theme.dart';
import 'package:myline_car/view/screens/splash/splash_screen.dart';
import 'package:myline_car/view_model/cars_provider.dart';
import 'package:myline_car/view_model/firebase_auth_provider.dart';
import 'package:myline_car/view_model/orders_provider.dart';
import 'package:myline_car/view_model/user_provider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CarsProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: MaterialApp(
        title: 'MyLine - Car',
        theme: MyLineTheme.lightThemeData(),
        home: const SplashScreen(),
      ),
    );
  }
}
