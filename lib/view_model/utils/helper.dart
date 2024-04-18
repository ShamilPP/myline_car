import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class Helper {
  static get imageLoadingBuilder => (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
          ),
        );
      };

  static String commonImageName(String imageExtension) {
    return 'IMG-${DateTime.now().millisecondsSinceEpoch}$imageExtension';
  }

  static Future<bool> turnOnLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled.', backgroundColor: Colors.red);
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied', backgroundColor: Colors.red);
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permissions are permanently denied, we cannot request permissions.Please turn on permission in settings', backgroundColor: Colors.red);
    }
    return serviceEnabled && (permission == LocationPermission.whileInUse || permission == LocationPermission.always);
  }
}

extension CheckingLink on String {
  bool get isLink => contains('https://');
}
