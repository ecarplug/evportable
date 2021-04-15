import 'dart:ui';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart';
import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/models/country_phone_code.dart';
import 'package:ecarplugapp/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageState implements GlobalBaseState, Cloneable<LoginPageState> {
  String account = '';
  String pwd = '';
  bool emailLogin;
  TextEditingController accountTextController;
  TextEditingController passWordTextController;
  TextEditingController phoneTextController;
  TextEditingController codeTextContraller;
  AnimationController animationController;
  AnimationController submitAnimationController;
  FocusNode accountFocusNode;
  FocusNode pwdFocusNode;
  String countryCode;
  List<CountryPhoneCode> countryCodes;
  SharedPreferences prefs;
  @override
  LoginPageState clone() {
    return LoginPageState()
      ..account = account
      ..pwd = pwd
      ..emailLogin = emailLogin
      ..accountFocusNode = accountFocusNode
      ..pwdFocusNode = pwdFocusNode
      ..animationController = animationController
      ..submitAnimationController = submitAnimationController
      ..accountTextController = accountTextController
      ..passWordTextController = passWordTextController
      ..phoneTextController = phoneTextController
      ..codeTextContraller = codeTextContraller
      ..countryCode = countryCode
      ..prefs = prefs
      ..countryCodes = countryCodes;
  }

  @override
  Color themeColor;

  @override
  Locale locale;

  @override
  AppUser user;
}

LoginPageState initState(Map<String, dynamic> args) {
  return LoginPageState();
}
