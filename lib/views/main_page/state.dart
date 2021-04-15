import 'package:ecarplugapp/globalbasestate/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/models/app_user.dart';

class MainPageState implements GlobalBaseState, Cloneable<MainPageState> {
  int selectedIndex = 0; // 초기 페이지 설정
  List<Widget> pages;
  PageController pageController;
  FirebaseUser firebaseUser;
  GlobalKey<ScaffoldState> scaffoldkey;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  MainPageState clone() {
    return MainPageState()
      ..pages = pages
      ..selectedIndex = selectedIndex
      ..scaffoldKey = scaffoldKey
      ..user = user
      ..firebaseUser = firebaseUser
      ..locale = locale;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

MainPageState initState(Map<String, dynamic> args) {
  // MainPageState()..selectedIndex = args['page'];
  // return MainPageState()..pages = args['pages'];
  final user = GlobalStore.store.getState().user?.firebaseUser;

  FirebaseAuth auth = FirebaseAuth.instance;

  MainPageState state = MainPageState();
  state.scaffoldkey = GlobalKey<ScaffoldState>();
  if (args['page'] != null) state.selectedIndex = args['page'];
  state.pages = args['pages'];
  //state.user.firebaseUser = user;
  auth.currentUser().then((value) => {state.firebaseUser = value});
  return state;
}
