import 'package:ecarplugapp/models/app_user.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/views/account_page/state.dart';
import 'package:flutter/material.dart';

class BodyState implements Cloneable<BodyState> {
  AppUser user;
  GlobalKey<ScaffoldState> scaffoldkey;
  @override
  BodyState clone() {
    return BodyState()..scaffoldkey = scaffoldkey;
  }
}

class BodyConnector extends ConnOp<AccountPageState, BodyState> {
  @override
  BodyState get(AccountPageState state) {
    BodyState substate = new BodyState();
    substate.user = state.user;
    substate.scaffoldkey = GlobalKey<ScaffoldState>();
    return substate;
  }
}
