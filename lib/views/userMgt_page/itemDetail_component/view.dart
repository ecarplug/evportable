/*import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    ItemDetailState state, Dispatch dispatch, ViewService viewService) {
  return Text("===========>" + state.nickname);
}*/
 
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/actions/adapt.dart'; 
import 'package:ecarplugapp/style/themestyle.dart'; 

import '../action.dart';
import 'state.dart';

Widget buildView(
    ItemDetailState state, Dispatch dispatch, ViewService viewService) {
  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);
  var itemDetailData = state.itemDetailData;

  var chargedTime = "00:00:00";
  if (itemDetailData["charged_time"].toString().length > 5) {
    chargedTime = itemDetailData["charged_time"].toString();
  }

  return GestureDetector(
    key: ValueKey(
        'itemDetailData${itemDetailData['deviceId']}+${itemDetailData['deviceId']}'),
    onTap: () => {print('test')},
    child: Container(
      margin: EdgeInsets.only(
          bottom: Adapt.px(0), left: Adapt.px(0), right: Adapt.px(0)),
      decoration: BoxDecoration(
        color: _theme.cardColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              blurRadius: Adapt.px(0),
              offset: Offset(Adapt.px(0), Adapt.px(0)),
              color: _theme.primaryColorDark)
        ],
        borderRadius: BorderRadius.circular(Adapt.px(0)),
      ),
      child: GestureDetector(
        onTap: () => dispatch(BangtalboardActionCreator.detailList(
            d: {'itemDetailData': itemDetailData})),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(alignment: Alignment.centerLeft,
                    width: 60, child: Text(itemDetailData["user_nm"])),
                Container(
                    alignment: Alignment.centerRight,
                    width: 50,
                    child: Text(itemDetailData["totalCnt"].toString())),
                Container(
                    alignment: Alignment.centerRight,
                    width: 50,
                    child: Text(itemDetailData["totalkW"].toString())),
                Container(height: 50, child: Text('')),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
