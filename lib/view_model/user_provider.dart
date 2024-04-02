import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myline_car/model/result.dart';

import '../model/user.dart';
import '../service/firebase_services.dart';
import '../service/local_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  List<User> allClientUsers = [];

  User? get user => _user;

  Future<User?> loadUser() async {
    String? userId = await LocalService.getUserId();
    if (userId != null) {
      var result = await FirebaseService.getUserWithUserId(userId);
      if (result.status == Status.success) {
        _user = result.data;
        return _user;
      } else {
        Fluttertoast.showToast(msg: result.message!, backgroundColor: Colors.red);
      }
    }
    await LocalService.removeUser();
    return null;
  }

  void loadAllUsers() async {
    await FirebaseService.getClientUsers().then((result) {
      if (result.status == Status.success) {
        allClientUsers = result.data!;
      }
    });
  }

  Future saveUser(User usr) async {
    // Check user already account created just login else case create new account
    var result = await FirebaseService.getUserWithPhone(usr.phone);
    if (result.status == Status.success) {
      if (result.data != null) {
        _user = result.data;
        await LocalService.setUserId(_user!);
      } else {
        //The getUserWithPhone function returns 'success' and 'null' indicates that no users were found with that phone number without any errors.
        // Then create new account
        var result = await FirebaseService.createNewCarOwner(usr);
        if (result.status == Status.success) {
          _user = result.data;
          await LocalService.setUserId(_user!);
        } else {
          Fluttertoast.showToast(msg: result.message!, backgroundColor: Colors.red);
        }
      }
    } else {
      Fluttertoast.showToast(msg: result.message!, backgroundColor: Colors.red);
    }
  }

  Future updateUser(User usr) async {
    var result = await FirebaseService.updateUser(usr);
    if (result.status == Status.error) {
      Fluttertoast.showToast(msg: result.message!, backgroundColor: Colors.red);
    }
  }

  Future removeUser() async {
    await LocalService.removeUser();
  }
}
