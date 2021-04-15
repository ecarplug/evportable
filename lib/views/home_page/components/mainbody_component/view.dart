import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecarplugapp/views/home_page/action.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/actions/imageurl.dart';
import 'package:ecarplugapp/generated/i18n.dart';
import 'package:ecarplugapp/models/enums/imagesize.dart';
import 'package:ecarplugapp/models/video_list.dart';
import 'package:ecarplugapp/style/themestyle.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:shimmer/shimmer.dart';
import 'state.dart';

Widget buildView(
    PopularPosterState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    children: <Widget>[
      _FrontTitel(
        showMovie: state.showmovie,
        dispatch: dispatch,
      ),
      SizedBox(height: Adapt.px(30)),
      Card(
          child: Container(
              padding: const EdgeInsets.all(0),
              child: GestureDetector(

                  // final pageController = PageController();
                  child: Container(
                      //color: Colors.w,
                      padding: const EdgeInsets.all(0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(viewService.context)
                                        .size
                                        .width -
                                    10,
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Container(
                                            color: Colors.grey[600],
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height: 25,
                                                ),
                                                Text(
                                                  "Charger ID",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),

                                                Text(
                                                  "Start Time",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                //Text(" ~ "),
                                                Text(
                                                  "Chg. Time",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                //Text(" ~ "),
                                                Text(
                                                  'PWR(kW)',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ))
                                    ])),
                          ]))))),
      for (int i = 0; i < state.boardList.length; i++)
        (_Boarditem(index: i, boardList: state.boardList, dispatch: dispatch)),
    ],
  );
}

class _ShimmerCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Adapt.px(250),
      height: Adapt.px(350),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: Adapt.px(250),
            height: Adapt.px(350),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(Adapt.px(15)),
            ),
          ),
          SizedBox(
            height: Adapt.px(20),
          ),
          Container(
            width: Adapt.px(220),
            height: Adapt.px(30),
            color: const Color(0xFFEEEEEE),
          )
        ],
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Shimmer.fromColors(
        baseColor: _theme.primaryColorDark,
        highlightColor: _theme.primaryColorLight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          separatorBuilder: (_, __) => SizedBox(width: Adapt.px(30)),
          itemCount: 4,
          itemBuilder: (_, __) => _ShimmerCell(),
        ));
  }
}

class _Cell extends StatelessWidget {
  final VideoListResult data;
  final Function onTap;
  const _Cell({@required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return GestureDetector(
      key: ValueKey(data.id),
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            width: Adapt.px(250),
            height: Adapt.px(350),
            decoration: BoxDecoration(
              color: _theme.primaryColorDark,
              borderRadius: BorderRadius.circular(Adapt.px(15)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  ImageUrl.getUrl(data.posterPath, ImageSize.w400),
                ),
              ),
            ),
          ),
          Container(
            //alignment: Alignment.bottomCenter,
            width: Adapt.px(250),
            padding: EdgeInsets.all(Adapt.px(10)),
            child: Text(
              data.title ?? data.name,
              maxLines: 2,
              //textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Adapt.px(28),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MoreCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: _theme.primaryColorLight,
            borderRadius: BorderRadius.circular(Adapt.px(15)),
          ),
          width: Adapt.px(250),
          height: Adapt.px(350),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  I18n.of(context).more,
                  style: TextStyle(fontSize: Adapt.px(35)),
                ),
                Icon(Icons.arrow_forward, size: Adapt.px(35))
              ]),
        )
      ],
    );
  }
}

class _FrontTitel extends StatelessWidget {
  final bool showMovie;
  final Dispatch dispatch;
  const _FrontTitel({this.showMovie, this.dispatch});
  @override
  Widget build(BuildContext context) {
    final TextStyle _selectPopStyle = TextStyle(
      fontSize: Adapt.px(24),
      fontWeight: FontWeight.bold,
    );

    final TextStyle _unselectPopStyle =
        TextStyle(fontSize: Adapt.px(24), color: const Color(0xFF9E9E9E));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Charging History",
            style:
                TextStyle(fontSize: Adapt.px(35), fontWeight: FontWeight.bold),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                  onTap: () => dispatch(HomePageActionCreator.reflash()),
                  //  Navigator.of(context).pushNamed('ecarplugReportPage'),

                  //Navigator.pushReplacementNamed(context, 'bangtalboardPage'),
                  // final pageController = PageController();
                  //  child: Text('More',
                  //    style: showMovie ? _selectPopStyle : _unselectPopStyle),
                  child: Icon(Icons.refresh)),
            ],
          )
        ],
      ),
    );
  }
}

class _ImageCell extends StatelessWidget {
  final String url;
  const _ImageCell({this.url});
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = ThemeStyle.getTheme(context);
    return Container(
      // color: Colors.red,
      width: Adapt.px(130),
      //height: Adapt.px(200),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Adapt.px(30)),
        child: Container(
          color: _theme.primaryColorDark,
          child: ParallaxImage(
            extent: Adapt.px(200),
            image: url != ''
                ? CachedNetworkImageProvider(
                    ImageUrlDefault.getUrl(url, ImageSize.w200),
                  )
                : AssetImage("assets/icon/launcher_icon.png"),
          ),
        ),
      ),
    );
  }
}

/*
 Navigator.of(ctx.context)
      .pushNamed('bangtalDetailPage', arguments: action.payload)
*/
class _Boarditem extends StatelessWidget {
  final index;
  final List<DocumentSnapshot> boardList;
  final dispatch;

  const _Boarditem({this.index, this.boardList, this.dispatch});
  @override
  Widget build(BuildContext context) {
    var chargedTime = "00:00:00";
    if (boardList[index]["charged_time"].toString().length > 5) {
      chargedTime = boardList[index]["charged_time"].toString();
    }

    return Card(
        child: Container(
            padding: const EdgeInsets.all(5),
            child: GestureDetector(
                onTap: () => {
                      Navigator.of(context).pushNamed('bangtalDetailPage',
                          arguments: {
                            'bangtalboardDetail': boardList[index]
                          }).then(
                          (value) => dispatch(HomePageActionCreator.reflash()))
                    },
                // final pageController = PageController();
                child: Container(
                    //color: Colors.w,

                    padding: const EdgeInsets.all(0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 30,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.group_work,
                                                size: 15,
                                              ),
                                              Text(
                                                boardList[index]
                                                        ["deviceName"] ??
                                                    boardList[index]
                                                        ["deviceId"],
                                              )
                                            ],
                                          ),
                                          Text(
                                            boardList[index]["start"]
                                                .toDate()
                                                .toString()
                                                .substring(5, 16),
                                          ),
                                          Text(chargedTime),
                                          Row(
                                            children: <Widget>[
                                             
                                              Text((boardList[index]
                                                          ["get_energy"] ==
                                                      '')
                                                  ? '0.00'
                                                  : (boardList[index]
                                                              ["get_energy"] ??
                                                          0.00)
                                                      .toStringAsFixed(2)),
                                              Text("kwh"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ]))
                        ])))));
  }
}
