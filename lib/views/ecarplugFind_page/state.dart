import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/models/app_user.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

class EcarplugFindState
    implements GlobalBaseState, Cloneable<EcarplugFindState> {
  var chargeTime = "1111111111111";
  @override
  EcarplugFindState clone() {
    return EcarplugFindState()
      ..user = user
      ..themeColor = themeColor
      ..locale = locale
      ..chargeTime=chargeTime;
  }

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

EcarplugFindState initState(Map<String, dynamic> args) {
  return EcarplugFindState();
}
