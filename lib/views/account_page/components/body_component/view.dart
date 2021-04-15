import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/views/account_page/action.dart';
import 'package:toast/toast.dart';

import 'state.dart';

Widget buildView(BodyState state, Dispatch dispatch, ViewService viewService) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
    child: GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: Adapt.px(30),
      shrinkWrap: true,
      crossAxisCount: 2,
      children: <Widget>[
        _GirdCell(
            icon: 'images/option_icon_b.png',
            title: 'User Mgt',
            onTap: () => dispatch(
                AccountPageActionCreator.navigatorPush('userMgtPage'))),
        _GirdCell(
            icon: 'images/option_icon_b.png', title: 'Not yet', onTap: () => {}
            // dispatch(AccountPageActionCreator.navigatorPush('myListsPage')),
            ),
        _GirdCell(
          icon: 'images/option_icon_b.png',
          title: 'Not yet',
          onTap: () => 
           dispatch(AccountPageActionCreator.navigatorPush('ecarplugFilterPage')),
        ),
        _GirdCell(
            icon: 'images/option_icon_b.png',
            title: 'Not yet',
            onTap: () => {}),
        // dispatch(AccountPageActionCreator.navigatorPush('paymentPage'))),
        _GirdCell(
            icon: 'images/option_icon_b.png',
            title: 'Not yet',
            onTap: () => {}),
        //dispatch(    AccountPageActionCreator.navigatorPush('downloadPage'))),
        state.user != null
            ? _GirdCell(
                icon: 'images/profile.png',
                title: 'Change Profile',
                onTap: () => {
                  if (state.user != null)
                    {
                      dispatch(AccountPageActionCreator.settingCellTapped()),
                    }
                  else
                    {
                      Toast.show('Not Yet', state.scaffoldkey.currentContext),
                      Future.delayed(Duration(seconds: 5)).then((_) {
                        // pageController.jumpToPage(pageController.initialPage);
                      }),
                    }
                },
              )
            : _GirdCell(
                icon: 'images/r2d2.png',
                title: 'LOGIN',
                onTap: () => dispatch(AccountPageActionCreator.onLogin())),
      ],
    ),
  );
}

class _GirdCell extends StatelessWidget {
  final Function onTap;
  final String icon;
  final String title;

  const _GirdCell({this.icon, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final _lightTheme = ThemeData.light()
        .copyWith(cardColor: Colors.white, canvasColor: Colors.grey[300]);
    final _darkTheme = ThemeData.dark()
        .copyWith(cardColor: Color(0xFF505050), canvasColor: Color(0xFF404040));
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final ThemeData _theme = _mediaQuery.platformBrightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(
            Adapt.px(10), Adapt.px(10), Adapt.px(10), Adapt.px(30)),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(Adapt.px(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                blurRadius: Adapt.px(10),
                color: _theme.canvasColor,
                offset: Offset(0, Adapt.px(15)))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              icon,
              width: Adapt.px(100),
              height: Adapt.px(100),
            ),
            SizedBox(height: Adapt.px(20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(10)),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: Adapt.px(30), fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
