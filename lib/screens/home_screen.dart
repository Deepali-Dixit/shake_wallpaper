import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:shake_wallpaper/constants/keywords.dart';
import 'package:shake_wallpaper/models/documentWithCountModel.dart';
import 'package:shake_wallpaper/models/urlDocumentModel.dart';
import 'package:shake_wallpaper/models/userModel.dart';
import 'package:shake_wallpaper/screens/settings.dart';
import 'package:shake_wallpaper/screens/upload_wallpaper.dart';
import 'package:shake_wallpaper/services/firestoreService.dart';
import 'package:shake_wallpaper/services/phone_auth.dart';
import 'package:shake_wallpaper/utils/theme_notifier.dart';

import 'download_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirestoreService firestoreService;
  UserData _userData = UserData();
  ShakeDetector detector;
  DocumentWithCountModel _documentWithCountModel;
  UrLdocument _urlDocument;
  Map urlDocumentAsMap;
  int stackNumber = 1;
  createDetector() {
    detector = ShakeDetector.waitForStart(onPhoneShake: () {
      print("on phone shake called");
      detectorConfig();
    });
    detector.startListening();
  }

  detectorConfig() async {
    if (_documentWithCountModel != null &&
        stackNumber > ((_documentWithCountModel.count) / 10).ceil()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No more image available.'),
        ),
      );
      return;
    }
    // Do stuff on phone shake
    _documentWithCountModel =
        await firestoreService.natureWallpaperData(docNumber: stackNumber);
    _urlDocument = _documentWithCountModel?.document;
    print('detector called');
    urlDocumentAsMap = _urlDocument.toMap();
    setState(() {
      stackNumber++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestoreService = Provider.of<FirestoreService>(context, listen: false);
    createDetector();
    detectorConfig();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    detector.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    firestoreService = Provider.of<FirestoreService>(context);
    _userData = Provider.of<UserData>(context);
    print('************************');
    ConnectivityResult connectivityResult =
        Provider.of<ConnectivityResult>(context);
    //  ThemeData theme=themeNotifier.getTheme();
    return Consumer<ThemeNotifier>(builder: (context, themenotifier, child) {
      ThemeData theme = themenotifier.getTheme();
      return (_urlDocument == null)
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
              backgroundColor: theme.backgroundColor,
              appBar: appBar(context),
              body: Center(
                child: Container(
                    child: GridView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: _documentWithCountModel.count,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.5),
                  itemBuilder: (BuildContext context, int index) {
                    print(index + 1);
                    String url = urlDocumentAsMap['url${index + 1}'];
                    // print(_urlDocument.toMap());
                    return _urlDocument != null
                        ? url == null
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DownloadScreen(imgPath: url),
                                      fullscreenDialog: true));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: url,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )
                        // : Image.network(url)
                        : Container();
                  },
                )),
              ),
            );
    });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Nature wallpaper',
      ),
      actions: [
        _userData?.role == APP_ADMIN
            ? IconButton(
                icon: Icon(Icons.upload_outlined),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UploadWallpaperScreen()));
                })
            : Container(),
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            })
      ],
    );
  }
}
