import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';

class LocalService {
  static Future<String?> getUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? id = sharedPreferences.getString('id');
    return id;
  }

  static Future<bool> setUserId(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('id', user.id!);
    return true;
  }

  static Future<bool> removeUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('id');
    return true;
  }
}
