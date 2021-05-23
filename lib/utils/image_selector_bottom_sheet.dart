// import 'dart:io';
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shake_wallpaper/widgets/custom_button.dart';

PickedFile imageFile;

class BottomSheetWidget extends StatelessWidget {
  final Function(PickedFile) selectImage;
  BottomSheetWidget(this.selectImage);
  final _picker = ImagePicker();
  void takePhotoByCamera(BuildContext context) async {
    Navigator.pop(context);
    await _picker.getImage(source: ImageSource.camera).then(selectImage);
  }

  void takePhotoByGallery(BuildContext context) async {
    Navigator.pop(context);
    await _picker.getImage(source: ImageSource.gallery).then(selectImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(24, 32, 54, 0.8),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.all(35),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: browseFromDeviceButton(context),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: clickNewPhotoButton(context),
            ),
          ],
        ),
      ),
    );
  }

  CustomButton browseFromDeviceButton(BuildContext context) => CustomButton(
        text: 'Browse from device',
        buttonColor: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          takePhotoByGallery(context);
        },
      );
  CustomButton clickNewPhotoButton(BuildContext context) => CustomButton(
        text: 'Click a new photo',
        buttonColor: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          takePhotoByCamera(context);
        },
      );
}
