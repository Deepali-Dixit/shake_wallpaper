// import 'dart:io';
// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    var heightPiece = MediaQuery.of(context).size.height / 10;
    var widthPiece = MediaQuery.of(context).size.width / 10;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      height: heightPiece * 2.5,
      width: widthPiece * 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Profile photo",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(
                right: widthPiece * 2,
                top: heightPiece * 0.2,
                left: widthPiece),
            child: Row(
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    takePhotoByCamera(context);
                  },
                  label: Text("Camera"),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takePhotoByGallery(context);
                  },
                  label: Text("Gallery"),
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}
