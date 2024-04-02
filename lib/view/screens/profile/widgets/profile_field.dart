import 'package:flutter/material.dart';
import 'package:myline_car/utils/colors.dart';

class ProfileField extends StatefulWidget {
  bool isMultiline;
  double padding;
  double? width, height;
  int aspectW, aspectH;
  TextInputType? inputType;
  TextEditingController myController;
  bool? enabled;

  ProfileField({
    super.key,
    required this.isMultiline,
    this.aspectH = 9,
    this.aspectW = 16,
    required this.myController,
    required this.padding,
    this.inputType,
    this.width,
    this.height,
    this.enabled,
  });

  @override
  State<ProfileField> createState() => _ProfileFieldState();
}

class _ProfileFieldState extends State<ProfileField> {
  //TextEditingController myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    widget.myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //if textfield to be aligned based on Aspect Ratio
    if (widget.isMultiline) {
      return AspectRatio(
        aspectRatio: widget.aspectW / widget.aspectH,
        child: Padding(
          padding: EdgeInsets.all(widget.padding),
          child: TextField(
            enabled: widget.enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: colors.primaryColor, width: 2)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: colors.primaryColor, width: 2.0),
              ),
            ),
            controller: widget.myController,
            keyboardType: TextInputType.multiline,
            maxLines: 9,
          ),
        ),
      );
    } else {
      return Container(
        height: widget.height,
        padding: EdgeInsets.all(widget.padding),
        child: TextField(
          enabled: widget.enabled,
          maxLines: 1,
          keyboardType: (widget.inputType == null) ? TextInputType.text : widget.inputType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide(color: colors.primaryColor, width: 2)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(color: colors.primaryColor, width: 2.0),
            ),
          ),
          controller: widget.myController,
        ),
      );
    }
  }
}
