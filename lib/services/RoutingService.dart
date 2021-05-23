import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shake_wallpaper/models/userModel.dart';
import 'package:shake_wallpaper/screens/home_screen.dart';
import 'package:shake_wallpaper/screens/login_screen.dart';
import 'package:shake_wallpaper/screens/registration.dart';
import 'package:shake_wallpaper/services/firebaseStorageService.dart';
import 'package:shake_wallpaper/services/firestoreService.dart';

class RouteBasedOnAuth extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  const RouteBasedOnAuth({Key key, this.builder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null)
              return MultiProvider(providers: [
                Provider<FirestoreService>(
                  create: (_) =>
                      FirestoreService(phoneNo: snapshot.data.phoneNumber),
                ),
                Provider<FirebaseStorageService>(
                  create: (_) => FirebaseStorageService(),
                ),
                StreamProvider<UserData>.value(
                  value: FirestoreService(phoneNo: snapshot.data.phoneNumber)
                      .currentUserDocFromDBMappedIntoLocalUserData,
                ),
              ], child: builder(context, snapshot));
            else
              return builder(context, snapshot);
          }

          return CircularProgressIndicator();
        });
  }
}

class Routewidget extends StatelessWidget {
  final AsyncSnapshot<User> currentUserSnapshot;

  const Routewidget({Key key, this.currentUserSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentUserSnapshot.data != null) {
      FirestoreService _firestoreService =
          Provider.of<FirestoreService>(context);
      return StreamBuilder<UserData>(
          stream: _firestoreService.currentUserDocFromDBMappedIntoLocalUserData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            if (snapshot.connectionState == ConnectionState.active) {
              print(snapshot.data.toString());
              return snapshot.data != null
                  ? HomeScreen()
                  : CustomerRegistration();
            }
          });
    } else if (currentUserSnapshot.data == null) return LogInScreen();

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
