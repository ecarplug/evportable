import 'package:ecarplugapp/widgets/sliverappbar_delegate.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/style/themestyle.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    BangtalboardState state, Dispatch dispatch, ViewService viewService) {
  // final _adapter = viewService.buildAdapter();
  final _adapter = viewService.buildAdapter();
  return Builder(builder: (context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Scaffold(
        appBar: AppBar(
          brightness: _theme.brightness,
          backgroundColor: _theme.bottomAppBarColor,
          elevation: 0.0,
          iconTheme: _theme.iconTheme,
          title: Text(
              'Charging History  ' +
                  ((state.userNm != "") ? " ID: " + state.userNm : ""),
              style: TextStyle(color: _theme.primaryColorLight)),
          actions: <Widget>[
            InkWell(
              splashColor: Colors.blue, // splash color
              onTap: () => dispatch(
                  BangtalboardActionCreator.reflash()), // button pressed
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.loop, color: Colors.white), // icon
                  //Text("신규"), // text
                  Text('',
                      style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: Adapt.px(25))),
                  SizedBox(
                    width: 20,
                    height: 30,
                  )
                ],
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => dispatch(BangtalboardActionCreator.reflash()),
          child: CustomScrollView(
            key: ValueKey(state.hashCode),
            physics: BouncingScrollPhysics(),
            controller: state.controller,
            slivers: <Widget>[
              SliverPersistentHeader(
                floating: true,
                delegate: SliverAppBarDelegate(
                    minHeight: Adapt.px(170),
                    maxHeight: Adapt.px(170),
                    child: Column(
                      children: [
                        _FilterBar(
                          state: state,
                          isCharger: state.isCharger,
                          isbusy: state.isbusy,
                          onFilterPress: () =>
                              dispatch(BangtalboardActionCreator.filterTap()),
                          switchMedia: (isCharger) => dispatch(
                              BangtalboardActionCreator.mediaTypeChange(
                                  isCharger)),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                              height: 30,
                              color: Colors.grey[500],
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Charger ID",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //Text("  "),
                                  Text(
                                    "Start Time",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //Text(" ~ "),
                                  Text(
                                    "Chg.Time",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //Text(" ~ "),
                                  Text(
                                    'PWR(kW)',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    )),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate((ctx, index) {
                  return _adapter.itemBuilder(ctx, index);
                }, childCount: _adapter.itemCount),
              ),
              //   if (state.isLoading) _Loading(),
            ],
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.stop),
                onPressed: () {
                  print('test');
                },
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.email),
                onPressed: () async {
                  dispatch(BangtalboardActionCreator.getCVS());
                  /*
                var flutterBlue = FlutterBlue.instance;
                await flutterBlue.stopScan();
                for (var device in await flutterBlue.connectedDevices) {
                  await device.disconnect();
                }
                flutterBlue = null;
*/
                },
              );
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
            //color: Colors.grey[600],
            child: SizedBox(
                width: MediaQuery.of(viewService.context).size.width - 0,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(0.0)),
                  child: Container(
                    color: Colors.grey[500],
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(width: 50),
                        Text(
                          "Total ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        Icon(Icons.alarm),
                        SizedBox(width: 5),
                        Text(
                          state.totalTimeText,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 30),

                        Icon(Icons.electric_car),
                        SizedBox(width: 5),
                        Text(
                          state.totalpwr.toStringAsFixed(2),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "kW",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                          width: 25,
                        )
                        //   IconButton(icon: Icon(Icons.menu), onPressed: () {},),
                        //   IconButton(icon: Icon(Icons.search), onPressed: () {},),
                      ],
                    ),
                  ),
                ))));
  });
}

class _Refreshing extends StatelessWidget {
  final AnimationController refreshController;
  const _Refreshing({this.refreshController});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: refreshController,
          curve: Curves.ease,
        )),
        child: SizedBox(
          height: Adapt.px(5),
          child: LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF505050)),
          ),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final Function(bool) switchMedia;
  final bool isCharger;
  final bool isbusy;
  final Function onFilterPress;
  final BangtalboardState state;
  const _FilterBar(
      {this.switchMedia,
      this.onFilterPress,
      this.isbusy,
      this.isCharger,
      this.state});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    return Container(
      color: _theme.canvasColor,
      child: Stack(children: [
        Container(
            margin: EdgeInsets.symmetric(
                horizontal: Adapt.px(30), vertical: Adapt.px(10)),
            padding: EdgeInsets.symmetric(
                vertical: Adapt.px(5), horizontal: Adapt.px(20)),
            height: Adapt.px(80),
            decoration: BoxDecoration(
              border: Border.all(
                  color: _theme.brightness == Brightness.light
                      ? const Color(0xFFEFEFEF)
                      : const Color(0xFF505050)),
              borderRadius: BorderRadius.circular(Adapt.px(20)),
              color: _theme.cardColor,
            ),
            child: GestureDetector(
                onTap: onFilterPress,
                child: Row(
                  children: [
                    SizedBox(height: 15),
                    Icon(Icons.date_range),
                    Text(state.startDate.toString().substring(0, 10)),
                    Text(" ~ "),
                    Text(state.endDate.toString().substring(0, 10)),
                    SizedBox(width: 15),
                    GestureDetector(
                      onTap: onFilterPress,
                      child: Container(
                        padding: EdgeInsets.all(Adapt.px(10)),
                        decoration: BoxDecoration(
                          color: const Color(0xFF334455),
                          borderRadius: BorderRadius.circular(Adapt.px(10)),
                        ),
                        child: Icon(
                          Icons.filter_list,
                          size: Adapt.px(30),
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(width: 15),
                    ),
                  ],
                ))),
        _Loading(isbusy: isbusy),
      ]),
    );
  }
}

class _TapPanel extends StatefulWidget {
  final bool isCharger;
  final bool isbusy;
  final Function(bool) onTap;
  const _TapPanel({this.onTap, this.isCharger, this.isbusy});
  @override
  _TapPanelState createState() => _TapPanelState();
}

class _TapPanelState extends State<_TapPanel> with TickerProviderStateMixin {
  AnimationController _controller;
  bool _isCharger;
  final TextStyle _seletedStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: Adapt.px(24));
  final TextStyle _unSelectedStyle =
      TextStyle(color: const Color(0xFF9E9E9E), fontSize: Adapt.px(24));

  Animation<Offset> _position;
  @override
  void didUpdateWidget(_TapPanel oldWidget) {
    if (widget.isCharger != _isCharger && !widget.isbusy) {
      widget.isCharger ? _controller.reverse() : _controller.forward();
      _isCharger = widget.isCharger;
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _isCharger = widget.isCharger ?? false;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _position = Tween<Offset>(begin: Offset.zero, end: Offset(1, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
    super.initState();
  }

  @override
  void dispose() {
    _controller?.stop();
    _controller?.dispose();
    super.dispose();
  }

  onTap(bool isCharger) {
    if (_isCharger == isCharger && widget.isbusy) return;
    if (widget.onTap != null) widget.onTap(isCharger);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    return Stack(children: [
      Row(children: [
        _TapCell(
          onTap: () => onTap(false),
          title: 'Time',
          textStyle: _isCharger ? _unSelectedStyle : _seletedStyle,
        ),
        _TapCell(
          onTap: () => onTap(true),
          title: 'Charger',
          textStyle: _isCharger ? _seletedStyle : _unSelectedStyle,
        )
      ])
      /*
      SlideTransition(
        position: _position,
        child: Container(
          padding: EdgeInsets.only(top: Adapt.px(50)),
          width: Adapt.px(100),
          child: Container(
            width: Adapt.px(8),
            height: Adapt.px(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _theme.brightness == Brightness.light
                  ? const Color(0xFF334455)
                  : const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
      */
    ]);
  }
}

class _TapCell extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  final Function onTap;
  const _TapCell({this.title, this.onTap, this.textStyle});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: Adapt.px(100),
        child: Center(
          child: Text(
            title,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  final bool isbusy;
  const _Loading({this.isbusy});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    final _brightness = _theme.brightness == Brightness.light;
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: isbusy
          ? Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.symmetric(
                  horizontal: Adapt.px(40), vertical: Adapt.px(10)),
              padding: EdgeInsets.symmetric(
                  vertical: Adapt.px(1), horizontal: Adapt.px(20)),
              height: Adapt.px(80),
              child: SizedBox(
                height: Adapt.px(2),
                child: LinearProgressIndicator(
                  backgroundColor: _brightness
                      ? const Color(0xFFEFEFEF)
                      : const Color(0xFF505050),
                  valueColor: AlwaysStoppedAnimation(
                    _brightness
                        ? const Color(0xFF334455)
                        : const Color(0xFFFFFFFF),
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
