import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myline_car/view/screens/profile/widgets/profile_field.dart';
import 'package:provider/provider.dart';

import '../../../model/user.dart';
import '../../../view_model/user_provider.dart';
import '../splash/splash_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showLoading = false;
  TextEditingController txtPhoneCtrl = TextEditingController();
  TextEditingController txtNameCtrl = TextEditingController();

  @override
  void initState() {
    var provider = Provider.of<UserProvider>(context, listen: false);
    if (provider.user != null) {
      txtNameCtrl.text = provider.user!.name;
      txtPhoneCtrl.text = provider.user!.phone;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            if (provider.user != null)
              IconButton(
                  onPressed: () {
                    logoutDialog(context);
                  },
                  icon: const Icon(Icons.power_settings_new))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  //Label and Text
                  children: <Widget>[
                    //Label
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 7, top: 5, left: 7),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              )),
                        ),
                      ),
                    ),

                    //TextField
                    Expanded(
                        flex: 3,
                        child: ProfileField(
                          height: 50,
                          myController: txtNameCtrl,
                          isMultiline: false,
                          padding: 5,
                        ))
                  ],
                ),
              ),

              //Phone
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Row(
                  //Label and Text
                  children: <Widget>[
                    //Label
                    const Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.only(right: 7, top: 5, left: 7),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              )),
                        ),
                      ),
                    ),

                    //TextField
                    Expanded(
                        flex: 3,
                        child: ProfileField(
                          enabled: provider.user == null,
                          height: 50,
                          inputType: TextInputType.phone,
                          myController: txtPhoneCtrl,
                          isMultiline: false,
                          padding: 5,
                        ))
                  ],
                ),
              ),
              //Save Button
              if (!showLoading)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        onPressed: saveUser,
                        child: Text((provider.user == null) ? 'Save' : 'Update'),
                      )),
                )
              else
                const Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: CircularProgressIndicator(),
                    ))
            ],
          ),
        ),
      );
    });
  }

  void saveUser() async {
    setState(() {
      showLoading = true;
    });
    if (txtNameCtrl.text.isNotEmpty && txtPhoneCtrl.text.isNotEmpty) {
      User user = User(name: txtNameCtrl.text, phone: txtPhoneCtrl.text);
      var provider = Provider.of<UserProvider>(context, listen: false);
      if (provider.user == null) {
        // await Provider.of<UserProvider>(context, listen: false).saveUser(user);
      } else {
        user.id = provider.user?.id;
        await Provider.of<UserProvider>(context, listen: false).updateUser(user);
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SplashScreen()));
    } else {
      Fluttertoast.showToast(msg: 'Fill all field');
    }
  }

  void logoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to logout'),
        actions: [
          TextButton(
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false).removeUser();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const SplashScreen()), (Route<dynamic> route) => false);
              },
              child: const Text('Yes'))
        ],
      ),
    );
  }
}
