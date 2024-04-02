import 'package:flutter/material.dart';

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
}

extension CheckingLink on String {
  bool get isLink => contains('https://');
}
