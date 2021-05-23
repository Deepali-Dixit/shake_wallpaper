import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shake_wallpaper/services/firebaseStorageService.dart';
import 'package:shake_wallpaper/services/firestoreService.dart';
import 'package:shake_wallpaper/widgets/bottomSheet.dart';
import 'package:shake_wallpaper/widgets/custom_button.dart';

class UploadWallpaperScreen extends StatefulWidget {
  @override
  _UploadWallpaperScreenState createState() => _UploadWallpaperScreenState();
}

class _UploadWallpaperScreenState extends State<UploadWallpaperScreen> {
  FirebaseStorageService _firebaseStorage;
  FirestoreService firestoreService;
  PickedFile _pickedFile;
  @override
  Widget build(BuildContext context) {
    _firebaseStorage = Provider.of<FirebaseStorageService>(context);
    firestoreService = Provider.of<FirestoreService>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Upload photo')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: buildBrowseButton(),
            ),
            Padding(padding: EdgeInsets.all(20), child: buildImageView()),
          ],
        ),
      ),
    );
  }

  GestureDetector buildBrowseButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: ((builder) => BottomSheetWidget((image) async {
                  setState(() {
                    _pickedFile = PickedFile(image.path);
                  });
                })));
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.search),
          SizedBox(width: 5),
          Text('Browse',
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15)),
        ],
      ),
    );
  }

  Column buildImageView() {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      (Container(
          foregroundDecoration: ShapeDecoration.fromBoxDecoration(
              BoxDecoration(border: Border.all())),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: (_pickedFile != null)
                ? Image.file(
                    File(_pickedFile.path),
                    fit: BoxFit.fill,
                  )
                : Container(child: Text('no image selected')),
          ))),
      SizedBox(height: 10),
      _pickedFile != null
          ? Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                  text: 'upload',
                  onPressed: () async {
                    await firestoreService
                        .uploadImageToStorageAndAddUrlToDocumentWithCountIncrement(
                            _firebaseStorage, _pickedFile);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Image uploaded successfully.'),
                      ),
                    );
                  }))
          : Container()
    ]);
  }
}
