import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/style/themestyle.dart';
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
        onTap: () => print("")
        //dispatch(BangtalboardActionCreator.detailList(
        //   d: {'bangtalboardDetail': itemDetailData})
        ,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(height: 50.0,),
                    Icon(
                      Icons.group_work,
                      size: 15,
                    ),
                    Text(
                      itemDetailData["deviceName"] ??
                          itemDetailData["deviceId"],
                    )
                  ],
                ),
                Text(
                  itemDetailData["start"].toDate().toString().substring(5, 16),
                ),
                Row(children: <Widget>[
                  Icon(
                    Icons.access_time_sharp,
                    size: 15,
                  ),
                  Text(chargedTime),
                ]),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time_sharp,
                      size: 15,
                    ),
                    Text((itemDetailData["get_energy"] == '')
                        ? '0.00'
                        : (itemDetailData["get_energy"]  ?? 0.00).toStringAsFixed(2)
                            ),
                    Text("kwh"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
