import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/widgets/backdrop.dart';
import 'package:ecarplugapp/generated/i18n.dart';
import 'package:ecarplugapp/style/themestyle.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    HomePageState state, Dispatch dispatch, ViewService viewService) {
  return Builder(
    builder: (context) {
      final ThemeData _theme = ThemeStyle.getTheme(context);
      return Scaffold(
        
        body: BackDrop(
          backLayerHeight: Adapt.px(880) + Adapt.padTopH(),
          backChild: viewService.buildComponent('header'),
          frontBackGroundColor: Colors.white,
          frontChildren: <Widget>[
            const _Line(),
            viewService.buildComponent('popularposter'),
          ],
        ),
      );
    },
  );
}

class Movie {
  final String title;
  final String genre;
  final String year;
  final String imageUrl;

  Movie({this.genre, this.title, this.year, this.imageUrl});
}

class _SearchBar extends StatelessWidget {
  final Function onTap;
  const _SearchBar({this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: Adapt.px(30), right: Adapt.px(30)),
        height: Adapt.px(70),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(40)),
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.grey,
            ),
            SizedBox(width: Adapt.px(20)),
            SizedBox(
              width: Adapt.screenW() - Adapt.px(200),
              child: Text(
                I18n.of(context).searchbartxt,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey, fontSize: Adapt.px(28)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Center(
        child: Container(
          width: 50,
          height: 5,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
