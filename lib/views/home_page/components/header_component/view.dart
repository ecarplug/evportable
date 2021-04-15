import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/style/themestyle.dart';
import 'package:ecarplugapp/generated/i18n.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    HeaderState state, Dispatch dispatch, ViewService viewService) {
  final ThemeData _theme = ThemeStyle.getTheme(viewService.context);
  return Container(
    color: _theme.bottomAppBarColor,
    child: Column(
      children: <Widget>[
        SizedBox(height: Adapt.px(30)),
        _TabTitel(
          isCharger: state.showHeaderMovie,
          onTap: () => dispatch(HeaderActionCreator.onHeaderFilterChanged(
              !state.showHeaderMovie)),
        ),
        SizedBox(height: Adapt.px(45)),
        _HeaderBody(
          data: state.banktalNewThema,
          dispatch: dispatch,
          isCharger: state.showHeaderMovie,
          userName :state.userName,
        ),
      ],
    ),
  );
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
          borderRadius: BorderRadius.circular(Adapt.px(60)),
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
              width: Adapt.screenW() - Adapt.px(400),
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

class _TabTitel extends StatelessWidget {
  final bool isCharger;
  final Function onTap;
  _TabTitel({this.isCharger, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: Adapt.px(30),
            ),
          ],
        ));
  }
}

class _HeaderBody extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final BorderRadius _baseBorderRadius = BorderRadius.circular(8);
  final List data;
  final bool isCharger;
  final Dispatch dispatch;
  final String userName;

  _HeaderBody(
      {this.data, this.dispatch, this.isCharger = true, this.onTap, this.child,this.userName})
      : assert(data != null);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: Adapt.px(900),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: Column(children: <Widget>[


          
          Container(
            color: Colors.blue[800],
            child: Row(
              children: <Widget>[
                SizedBox(
                        height: 240,
                      ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image(
                                image: AssetImage('images/icon/ecarplug.png'),
                                width: 150,
                                fit: BoxFit.fill),
                            Text(
                              'Welcome',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            ),
                            Text(
                               userName??"" '.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                      SizedBox(
                        width: 40,
                      ),
                      Image(
                          image: AssetImage('images/icon/Frame.png'),
                          width: 150,
                          fit: BoxFit.fill),
                    ],
                  ),
                )
              ],
            ),
          ),

      
          Stack(
            alignment: Alignment.topCenter,
  overflow: Overflow.visible,
  children: <Widget>[
     
     Container(
      color: Colors.grey[200]  ,
      height: 40,
     // width: 150,
    ),
      Container(
      color: Colors.blue[800],
      height: 20,
     // width: 150,
    ),
      SizedBox(
    //height: 100,
        width: 350,
        child: 
    Positioned(
      child:   _SearchBar(onTap: () => {print("test")}),
      right: 0,
      left: 0,
    //  bottom: -0,
    ),
      ),
  ],
),
 
      
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              mainIcon('Find', 'Charger', 'images/icon/findcharger.png', dispatch, 1),
              SizedBox(width:10),
              mainIcon(
                  'Charging', 'History', 'images/icon/chargingHistory-1.png', dispatch, 2),
            ],
          ),
          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }
}

Widget mainIcon(String iconText, String iconText2, String icon,
    Dispatch dispatch, int index) {
  // VoidCallback onTap;
  BorderRadius _baseBorderRadius = BorderRadius.circular(25);
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: _baseBorderRadius),
    child: InkWell(
      borderRadius: _baseBorderRadius,
      onTap: () => dispatch(HeaderActionCreator.cellTapped(index)),
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          width: 140,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: _baseBorderRadius,
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 0,
                ),
                ImageIcon(
    AssetImage( icon ),size: 50,color: Colors.blue[800],
  ),
 
                SizedBox(
                  height: 5,
                ),
                Text(
                  iconText,
                  style: TextStyle(color: Colors.blue[900], fontSize: 15),
                ),
                Text(
                  iconText2,
                  style: TextStyle(color: Colors.blue[900], fontSize: 15),
                )
              ],
            ),
          )),
    ),
  );
}

Widget mainIconWhite(
    String iconText, IconData icon, Dispatch dispatch, int index) {
  BorderRadius _baseBorderRadius = BorderRadius.circular(25);
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: _baseBorderRadius),
    child: InkWell(
      borderRadius: _baseBorderRadius,
      onTap: () => dispatch(HeaderActionCreator.cellTapped(index)),
      child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: _baseBorderRadius,
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  iconText,
                  style: TextStyle(color: Colors.white, fontSize: 13),
                )
              ],
            ),
          )),
    ),
  );
}
