import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myline_car/view_model/utils/helper.dart';

class CarDetailsPhoto extends StatefulWidget {
  final String? img;
  final void Function(String) onUpdate;

  const CarDetailsPhoto(this.img, {super.key, required this.onUpdate});

  @override
  State<CarDetailsPhoto> createState() => _CarDetailsPhotoState();
}

class _CarDetailsPhotoState extends State<CarDetailsPhoto> {
  String? image = '';

  @override
  void initState() {
    image = widget.img;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        child: InkWell(
          onTap: () async {
            if (image == null) {
              final ImagePicker picker = ImagePicker();
              final XFile? newImage = await picker.pickImage(source: ImageSource.gallery);
              if (newImage != null) {
                setState(() {
                  image = newImage.path;
                  widget.onUpdate(newImage.path);
                });
              }
            } else {
              Fluttertoast.showToast(msg: 'Unable to update the image during the updating process.');
            }
          },
          child: image != null
              ? image!.isLink
                  ? Image.network(image!, loadingBuilder: Helper.imageLoadingBuilder)
                  : Image.file(File(image!))
              : const SizedBox(),
        ),
      ),
    );
  }
}
