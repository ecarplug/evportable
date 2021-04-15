import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'app.dart'; 

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  await SystemChrome.setPreferredOrientations( // 새로방향 고정 취소
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //HttpOverrides.global = new MyHttpOverrides();

  runApp(App());
  /*
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
    routes: <String, WidgetBuilder>{
      '/HomeScreen': (BuildContext context) => new App()
    },
  ));
  */
}
