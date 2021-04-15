import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/models/app_user.dart';

class ProfileViewState implements GlobalBaseState, Cloneable<ProfileViewState> {
  DocumentSnapshot document;
  String userId;
  String userName;
  String photoUrl;
  TextEditingController contsCon = TextEditingController();
  DateTime mDate;
  TextEditingController nameTextController;
  TextEditingController descriptionTextController;
  FocusNode nameFoucsNode;
  FocusNode descriptionFoucsNode;
  bool loading;
  String commentDesc;
  GlobalKey<ScaffoldState> scaffoldkey;
  @override
  AppUser user;

  bool like = false, manner = false, reco = false;

  int likeCount = 0;
  int mannerCount = 0;
  int recoCount = 0;
  String statusMessage = "";

  @override
  ProfileViewState clone() {
    return ProfileViewState()
      ..userId = userId
      ..photoUrl = photoUrl
      ..userName = userName
      ..user = user
      ..like = like
      ..manner = manner
      ..reco = reco
      ..statusMessage = statusMessage
      ..likeCount = likeCount
      ..mannerCount = mannerCount
      ..recoCount = recoCount
      ..scaffoldkey = scaffoldkey
      ..descriptionTextController = descriptionTextController
      ..nameFoucsNode = nameFoucsNode
      ..descriptionFoucsNode = descriptionFoucsNode
      ..loading = loading
      ..commentDesc = commentDesc
      ..contsCon = contsCon;
  }

  @override
  Locale locale;

  @override
  Color themeColor;
}

ProfileViewState initState(Map<String, dynamic> args) {
  var state = ProfileViewState();
  state.userId = args['userId'];
  state.userName = args['userName'];
  state.photoUrl = args['photoUrl'];
  state.scaffoldkey = GlobalKey<ScaffoldState>();
  return state;

  // return ProfileViewState();
}
