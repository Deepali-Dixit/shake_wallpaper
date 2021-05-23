
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/scheduler.dart';

import 'package:provider/provider.dart';
import 'package:shake_wallpaper/services/RoutingService.dart';
import 'package:shake_wallpaper/utils/connectivityService.dart';
import 'package:shake_wallpaper/utils/theme_notifier.dart';
import 'package:shake_wallpaper/values/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('${snapshot.error}');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return RouteBasedOnAuth(
              builder: (BuildContext context, localUserSnapshot) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ThemeNotifier>(
                  create: (_) => ThemeNotifier(SchedulerBinding.instance.window.platformBrightness==Brightness.dark? darkTheme:lightTheme),
                ),
                StreamProvider<ConnectivityResult>.value(
                  value:
                      ConnectivityService().connectionStatusController.stream,
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Shake wallpaper',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: Routewidget(currentUserSnapshot: localUserSnapshot),
                // home: RoutingBasedOnAuth().checkAuth(),
              ),
            );
          });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
