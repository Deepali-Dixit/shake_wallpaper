import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shake_wallpaper/constants/keywords.dart';

class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadProfilePicAndGetUrl({
      @required String imageName,@required PickedFile file}) async {
    try {
      String url = await _firebaseStorage
          .ref(PROFILE_PIC_STORAGE_BUCKET)
          .child(imageName)
          .putFile(File(file.path))
          .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
      return url;
    } catch (e) {
      print(e);
    }
   
  }  Future<String> uploadWallpaperAndGetUrl({ @required PickedFile file}) async {
    try {
      String url = await _firebaseStorage
          .ref(WALLPAPERS_STORAGE_BUCKET)
          .child('${DateTime.now().toString()}.jpg')
          .putFile(File(file.path))
          .then((TaskSnapshot snapshot) => snapshot.ref.getDownloadURL());
      return url;
    } catch (e) {
      print(e);
    }
  }
}
