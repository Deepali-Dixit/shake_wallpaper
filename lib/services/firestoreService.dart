import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shake_wallpaper/constants/keywords.dart';
import 'package:shake_wallpaper/models/documentWithCountModel.dart';
import 'package:shake_wallpaper/models/urlDocumentModel.dart';
import 'package:shake_wallpaper/models/userModel.dart';
import 'package:shake_wallpaper/services/firebaseStorageService.dart';

class FirestoreService {
  final String phoneNo;
  int _lastcount;

  FirestoreService({this.phoneNo});
  // collection reference
  final CollectionReference userDataCollectionRefrence =
      FirebaseFirestore.instance.collection(USERS_COLLECTION);
  final CollectionReference natureWallpaperCollectionRefrence =
      FirebaseFirestore.instance.collection(NATURE_WALLPAPER_COLLECTION);
  final CollectionReference wallpaperCollectionReference =
      FirebaseFirestore.instance.collection(WALLPAPERS_COLLECTION);

//create user document in database
  Future createUserDoc(UserData userData) async {
    try {
      await userDataCollectionRefrence.doc(phoneNo).set(userData.toMap());
    } catch (e) {
      print(e);
    }
  }

  // get currentUserDataFromDB stream
  Stream<UserData> get currentUserDocFromDBMappedIntoLocalUserData {
    try {
      return userDataCollectionRefrence
          .doc(phoneNo)
          .snapshots()
          .map((event) => userDataFromMap(jsonEncode(event.data())));
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> get currentUserDocData async {
    try {
      return await FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(phoneNo)
          .get();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentWithCountModel> natureWallpaperData({int docNumber}) async {
    try {
      DocumentWithCountModel completeDocData;
      UrLdocument document = await natureWallpaperCollectionRefrence
          .doc('stack$docNumber')
          .get()
          .then((value) => UrLdocument.fromMap(value.data()));
      int count = await wallpaperCollectionReference
          .doc('category_count')
          .get()
          .then((snap) => snap.data()['nature_wallpaper']);
      completeDocData = DocumentWithCountModel(document, count);
      return completeDocData;
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadImageToStorageAndAddUrlToDocumentWithCountIncrement(
      FirebaseStorageService storageService, PickedFile imageFile) async {
    int count = await wallpaperCollectionReference
        .doc('category_count')
        .get()
        .then((snap) => snap.data()['nature_wallpaper']);
    int stackNumberFilled = (count / 10).floor();
    int urlNumberFilled = (count % 10);
    String imageUrl =
        await storageService.uploadWallpaperAndGetUrl(file: imageFile);
    await natureWallpaperCollectionRefrence
        .doc('stack${stackNumberFilled + 1}')
        .update({'url${urlNumberFilled + 1}': imageUrl});
    await wallpaperCollectionReference
        .doc('category_count')
        .update({'nature_wallpaper': FieldValue.increment(1)});
    return;
  }
}
