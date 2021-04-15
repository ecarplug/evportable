import 'package:ecarplugapp/style/themestyle.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'ex/BLEConnect.dart';
import 'ex/SelectBondedDevicePage.dart';
import 'state.dart';

Widget buildView(
    EcarplugBLEState state, Dispatch dispatch, ViewService viewService) {
  return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (c) {
          final MediaQueryData _mediaQuery = MediaQuery.of(c);
          final ThemeData _theme =
              _mediaQuery.platformBrightness == Brightness.light
                  ? ThemeStyle.lightTheme
                  : ThemeStyle.darkTheme;
          return BLETest();
        },
      ));
}

class BLETest extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '충전기 검색',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BLEConnect(),
      );
}
