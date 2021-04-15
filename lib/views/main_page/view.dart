import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/widgets/keepalive_widget.dart';
import 'package:ecarplugapp/generated/i18n.dart';
import 'package:toast/toast.dart';

import 'action.dart';
import 'state.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildView(
    MainPageState state, Dispatch dispatch, ViewService viewService) {
  return Builder(
    builder: (context) {
      Adapt.initContext(context);
      String cartName = "캇트";
      String appName = "이카플러그";

      String appCartName = appName + " " + cartName; // 공구임대 캇트

      int x = 1;
      int y = 2;
      int z = x + y;
      print(z);

      final pageController = PageController(initialPage: state.selectedIndex);
      final _lightTheme = ThemeData.light().copyWith(
          backgroundColor: Colors.white,
          tabBarTheme: TabBarTheme(
              labelColor: Color(0XFF505050),
              unselectedLabelColor: Colors.grey));
      final _darkTheme = ThemeData.dark().copyWith(
          backgroundColor: Color(0xFF303030),
          tabBarTheme: TabBarTheme(
              labelColor: Colors.white, unselectedLabelColor: Colors.grey));
      final MediaQueryData _mediaQuery = MediaQuery.of(context);
      final ThemeData _theme =
          _mediaQuery.platformBrightness == Brightness.light
              ? _lightTheme
              : _darkTheme;
      Widget _buildPage(Widget page) {
        return KeepAliveWidget(page);
      }

      return Scaffold(
        key: state.scaffoldKey,
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: state.pages.map(_buildPage).toList(),
          controller: pageController,
          onPageChanged: (int i) =>
              dispatch(MainPageActionCreator.onTabChanged(i)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: _theme.backgroundColor,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Image.asset( state.selectedIndex == 0?"images/icon/home_.png":"images/icon/home-.png", width: 30, height: 30) ,
              label: I18n.of(context).home,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                  state.selectedIndex == 1
                      ? FontAwesomeIcons.search
                      : FontAwesomeIcons.search,
                  size: Adapt.px(44)),
              label: I18n.of(context).find,
            ),
             BottomNavigationBarItem(
              icon:Image.asset( state.selectedIndex == 2?"images/icon/history_.png":"images/icon/history-.png", width: 30, height: 30) ,
              label: I18n.of(context).info,
            ),
                 BottomNavigationBarItem(
                icon: Icon(
                  state.selectedIndex == 3
                      ? Icons.more_horiz
                      : Icons.more_horiz,
                  size: Adapt.px(44),
                ),
                label: I18n.of(context).addview),
          ],
          currentIndex: state.selectedIndex,
          selectedItemColor: _theme.tabBarTheme.labelColor,
          unselectedItemColor: _theme.tabBarTheme.unselectedLabelColor,
          onTap: (int index) {
            //  FirebaseUser firebaseUser;
            final FirebaseAuth auth = FirebaseAuth.instance;
            auth.currentUser().then((value) => {
                  if (value == null && (index == 1 || index == 2 ))
                    {
                      Toast.show('You are not logged in. Please use after login.', context,
                          gravity: Toast.CENTER),
                      Future.delayed(Duration(seconds: 5)).then((_) {
                        // pageController.jumpToPage(pageController.initialPage);
                      })
                    }
                  else
                    {pageController.jumpToPage(index)}
                });
          },
          type: BottomNavigationBarType.fixed,
        ),
      );
    },
  );
}
