import 'dart:math';

import 'package:ecarplugapp/style/themestyle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/actions/imageurl.dart';
import 'package:ecarplugapp/models/enums/imagesize.dart';
import 'package:ecarplugapp/models/response_model.dart';
import 'package:ecarplugapp/models/search_result.dart';
import 'package:parallax_image/parallax_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecarplugapp/views/profileView_page/page.dart';

class SearchBarDelegate extends SearchDelegate<SearchResult> {
  SearchResultModel searchResultModel;
  List<String> searchHistory;
  List<String> searchRecommand = [
    'Seoul',
    'kang namm',
    'jaeju',
    'busan',
    //'부평',
    //'인천',
    //'경기(기타)',
    //'수원',
    //'안산',
    //'부산',
    //'대구',
    //'울산',
    //'대전',
    //'광주',
    //'경상',
    //'전라',
    //'충청',
    //'강원',
    //'제주',
  ];
  SharedPreferences prefs;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Future<ResponseModel<SearchResultModel>> _getData() {
    if (query != '' && query != null)
      //return TMDBApi.instance.searchMulit(query);
      return null;
    else
      return null;
  }

  Future<List<String>> _getHistory() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList('searchHistory') ?? List<String>();
    return searchHistory;
  }

/*
  @override
  Widget buildResults(BuildContext context) {
    if (prefs != null && query != '') {
      int index = searchHistory.indexOf(query);
      if (index < 0) {
        searchHistory.insert(0, query);
        prefs.setStringList('searchHistory', searchHistory);
      }
    }
    return FutureBuilder<ResponseModel<SearchResultModel>>(
      future: _getData(), // a previously-obtained Future<String> or null
      builder: (BuildContext context,
          AsyncSnapshot<ResponseModel<SearchResultModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Container(
              child: Center(
                child: Text('No Result'),
              ),
            );
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: Adapt.px(30)),
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return _ResultList(
              query: query,
              results: snapshot.data?.result?.results ?? [],
            );
        }
        return null;
      },
    );
  }
*/
  @override
  Widget buildResults(BuildContext context) {
    if (prefs != null && query != '') {
      int index = searchHistory.indexOf(query);
      if (index < 0) {
        searchHistory.insert(0, query);
        prefs.setStringList('searchHistory', searchHistory);
      }
    }
    return InfoScreen(
      query: query,
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder<List<String>>(
      future: _getHistory(), // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildHistoryList();
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: Adapt.px(30)),
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black)),
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.fromLTRB(Adapt.px(30), Adapt.px(30), 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Recommend',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Adapt.px(35)),
                          ),
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                    width: Adapt.screenW(),
                    child: Wrap(
                        spacing: Adapt.px(20),
                        children: searchRecommand.map((s) {
                          return ActionChip(
                            avatar: Icon(
                              Icons.history,
                              color: Colors.grey[500],
                            ),
                            // backgroundColor: Colors.grey[200],
                            label: Text(s),
                            //labelStyle: TextStyle(color: Colors.black87),
                            onPressed: () {
                              query = s;
                              showResults(context);
                            },
                          );
                        }).toList()),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.fromLTRB(Adapt.px(30), Adapt.px(30), 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'History',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: Adapt.px(35)),
                          ),
                          searchHistory.length > 0
                              ? SizedBox(
                                  height: Adapt.px(40),
                                  child: IconButton(
                                    padding: EdgeInsets.all(0),
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () {
                                      if (prefs != null &&
                                          searchHistory.length > 0) {
                                        searchHistory = List<String>();
                                        prefs.remove('searchHistory');
                                        query = '';
                                        showSuggestions(context);
                                      }
                                    },
                                  ),
                                )
                              : SizedBox()
                        ],
                      )),
                  searchHistory != null && searchHistory.length > 0
                      ? Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: Adapt.px(30)),
                          width: Adapt.screenW(),
                          child: Wrap(
                              spacing: Adapt.px(20),
                              children: searchHistory.map((s) {
                                return ActionChip(
                                  avatar: Icon(
                                    Icons.history,
                                    color: Colors.grey[500],
                                  ),
                                  // backgroundColor: Colors.grey[200],
                                  label: Text(s),
                                  //labelStyle: TextStyle(color: Colors.black87),
                                  onPressed: () {
                                    query = s;
                                    showResults(context);
                                  },
                                );
                              }).toList()),
                        )
                      : Container(
                          padding: EdgeInsets.only(left: Adapt.px(30)),
                          child: Text('no search history'),
                        ),
                ],
              ),
            );
        }
        return null;
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    /*
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("bangTalCafeThema")
          .where("thema", isGreaterThanOrEqualTo: '강')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildHistoryList();
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Container(
              margin: EdgeInsets.only(top: Adapt.px(30)),
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black)),
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return _SuggestionList(
              query: query,
              suggestions: snapshot.data.documents ?? [],
              onSelected: (String suggestion) {
                query = suggestion;
                showResults(context);
              },
            );
        }
        return null;
      },
    );
  }
*/

    return _buildHistoryList();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);

    assert(theme != null);
    final _lightTheme = theme.copyWith(
      inputDecorationTheme:
          InputDecorationTheme(hintStyle: TextStyle(color: Colors.grey)),
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
    final _darkTheme = theme.copyWith(
      inputDecorationTheme:
          InputDecorationTheme(hintStyle: TextStyle(color: Colors.grey)),
      primaryColor: Color(0xFF303030),
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.dark,
      primaryTextTheme: theme.textTheme,
    );
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final ThemeData _newtheme =
        _mediaQuery.platformBrightness == Brightness.light
            ? _lightTheme
            : _darkTheme;
    return _newtheme;
  }
}

Widget _buildSuggestionCell(SearchResult s, ValueChanged<String> tapped) {
  IconData iconData = s.mediaType == 'movie'
      ? Icons.movie
      : s.mediaType == 'tv'
          ? Icons.live_tv
          : Icons.person;
  String name = s.mediaType == 'movie' ? s.title : s.name;
  return Container(
      height: Adapt.px(100),
      child: ListTile(
        leading: Icon(iconData),
        title: new Text(name),
        onTap: () => tapped(name),
      ));
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<SearchResult> suggestions;
  final String query;
  final ValueChanged<String> onSelected;
/*
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final SearchResult suggestion = suggestions[i];
        return _buildSuggestionCell(suggestion, onSelected);
      },
    );
  }
 
*/
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: Firestore.instance
              .collection("bangTalCafeThema")
              .where("thema", isGreaterThanOrEqualTo: query)
              .limit(20)
              .getDocuments(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot user = snapshot.data.documents[index];
/*
                  return SingleIngredient(
                    // Access the fields as defined in FireStore
                    ingredient_name: user.data['ingredients'][index].toString(),
                  );
*/
                  return ListTile(title: snapshot.data[index].thema);
                },
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData) {
              // Handle no data
              return Center(
                child: Text("No users found."),
              );
            } else {
              // Still loading
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

Random _random = Random(DateTime.now().millisecondsSinceEpoch);

Widget _buildResultCell(SearchResult s, BuildContext ctx) {
  IconData iconData = s.mediaType == 'movie'
      ? Icons.movie
      : s.mediaType == 'tv'
          ? Icons.live_tv
          : Icons.person;
  String imageurl = s.mediaType != 'person' ? s.posterPath : s.profilePath;
  String name = s.mediaType == "movie" ? s.title : s.name;
  return GestureDetector(
    child: Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(20)),
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: Adapt.px(240),
              height: Adapt.px(350),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(
                      _random.nextInt(255),
                      _random.nextInt(255),
                      _random.nextInt(255),
                      _random.nextDouble()),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(imageurl == null
                          ? ImageUrl.emptyimage
                          : ImageUrl.getUrl(imageurl, ImageSize.w300)))),
            ),
            SizedBox(
              width: Adapt.px(20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: Adapt.px(20),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      iconData,
                      size: Adapt.px(40),
                    ),
                    SizedBox(
                      width: Adapt.px(10),
                    ),
                    Container(
                      width: Adapt.screenW() - Adapt.px(370),
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Adapt.px(30)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Adapt.px(10),
                ),
                s.mediaType != 'person'
                    ? Container(
                        width: Adapt.screenW() - Adapt.px(320),
                        child: Text(
                          s.overview ?? 'no description',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 7,
                          style: TextStyle(
                              fontSize: Adapt.px(26), wordSpacing: 1.2),
                        ),
                      )
                    : Container(
                        width: Adapt.screenW() - Adapt.px(320),
                        child: Wrap(
                          spacing: Adapt.px(10),
                          children: s.knownFor.map((d) {
                            return Chip(
                              backgroundColor: Colors.grey[200],
                              label: Text(
                                d.title ?? '',
                                style: TextStyle(fontSize: Adapt.px(24)),
                              ),
                            );
                          }).toList(),
                        )),
              ],
            )
          ],
        ),
      ),
    ),
    onTap: () async {
      switch (s.mediaType) {
        case 'movie':
          return await Navigator.of(ctx).pushNamed('detailpage', arguments: {
            'id': s.id,
            'bgpic': s.posterPath,
            'title': s.title,
            'posterpic': s.posterPath
          });
        case 'tv':
          return await Navigator.of(ctx).pushNamed('tvShowDetailPage',
              arguments: {
                'id': s.id,
                'bgpic': s.backdropPath,
                'name': s.name,
                'posterpic': s.posterPath
              });
        case 'person':
          return await Navigator.of(ctx).pushNamed('peopledetailpage',
              arguments: {
                'peopleid': s.id,
                'profilePath': s.profilePath,
                'profileName': s.name
              });
        default:
          return null;
      }
    },
  );
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

class InfoScreen extends StatefulWidget {
  static const String id = 'info_screen';

  final String query;
  @override
  _InfoScreenState createState() => _InfoScreenState();
  InfoScreen({@required this.query});
}

class _InfoScreenState extends State<InfoScreen> {
  List<DocumentSnapshot> cafeList = [];
  @override
  // TODO: implement widget
  InfoScreen get widget => super.widget;

  @override
  void initState() {
    _createList(context);
    super.initState();
  }

  Future<void> humanList(BuildContext context, List<String> str) async {
    if (cafeList.length < 10) {
      Firestore.instance
          .collection("users")
          .orderBy('nickname')
          .startAt([widget.query])
          .endAt([widget.query + '\uf8ff'])
          .limit(20)
          .getDocuments()
          .then((value) => {
                value.documents.forEach((element) {
                  cafeList.add(element);
                }),
                //  etcSearchList(context, str),
                setState(() {})
              });
    }
  }

  Future<void> cafeSearchList(BuildContext context, List<String> str) async {
    if (cafeList.length < 10) {
      if (str.length == 2) {
        Firestore.instance
            .collection("bangTalCafeThema")
            .where("area", isEqualTo: str[0])
            .orderBy('cafe_name')
            .startAt([str[1]])
            .endAt([str[1] + '\uf8ff'])
            .limit(10)
            .getDocuments()
            .then((value) => {
                  value.documents.forEach((element) {
                    cafeList.add(element);
                  }),
                  etcSearchList(context, str),
                  setState(() {})
                });
      } else {
        Firestore.instance
            .collection("bangTalCafeThema")
            .orderBy('cafe_name')
            .startAt([widget.query])
            .endAt([widget.query + '\uf8ff'])
            .limit(10)
            .getDocuments()
            .then((value) => {
                  value.documents.forEach((element) {
                    cafeList.add(element);
                  }),
                  etcSearchList(context, str),
                  setState(() {})
                });
      }
    }
  }

  Future<void> etcSearchList(BuildContext context, List<String> str) async {
    if (cafeList.length < 10) {
      Firestore.instance
          .collection("bangTalCafeThema")
          .orderBy('genre')
          .startAt([widget.query])
          .endAt([widget.query + '\uf8ff'])
          .limit(10)
          .getDocuments()
          .then((value) => {
                value.documents.forEach((element) {
                  cafeList.add(element);
                }),
                setState(() {})
              });

      Firestore.instance
          .collection("bangTalCafeThema")
          .orderBy('area')
          .startAt([widget.query])
          .endAt([widget.query + '\uf8ff'])
          .limit(10)
          .getDocuments()
          .then((value) => {
                value.documents.forEach((element) {
                  cafeList.add(element);
                }),
                humanList(context, str),
                setState(() {
                  // isLoading = true;
                })
              });
    }
  }

  Future<void> _createList(BuildContext context) async {
    List<String> str = widget.query.split(" ");
    if (str.length == 2) {
      Firestore.instance
          .collection("bangTalCafeThema")
          .where("area", isEqualTo: str[0])
          .orderBy('thema')
          .startAt([str[1]])
          .endAt([str[1] + '\uf8ff'])
          .limit(10)
          .getDocuments()
          .then((value) => {
                value.documents.forEach((element) {
                  cafeList.add(element);
                }),
                cafeSearchList(context, str),
                setState(() {})
              });
    } else {
      Firestore.instance
          .collection("bangTalCafeThema")
          .orderBy('thema')
          .startAt([widget.query])
          .endAt([widget.query + '\uf8ff'])
          .limit(10)
          .getDocuments()
          .then((value) => {
                value.documents.forEach((element) {
                  cafeList.add(element);
                }),
                cafeSearchList(context, str),
                setState(() {})
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        shrinkWrap: true,
        itemCount: cafeList.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Padding(
                padding: EdgeInsets.only(bottom: Adapt.px(20)),
                child: (cafeList[index]["cafe_name"] != null)
                    ? Card(
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 70, // hard coding child width
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            //color: ,
                                            child: Column(
                                              children: [
                                                _ImageCell(
                                                    url: cafeList[index]
                                                        ["posterPath"]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                    cafeList[index]
                                                        ["cafe_name"],
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xFF9E9E9E),
                                                        fontSize:
                                                            Adapt.px(22))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(cafeList[index]["thema"],
                                                    style: TextStyle(
                                                        //   color: const Color(
                                                        //     0xFF9E9E9E),
                                                        fontSize:
                                                            Adapt.px(25))),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            cafeList[index]['conts'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: Adapt.px(24)),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            )),
                      )
                    : Card(
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 70, // hard coding child width
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            //color: ,
                                            child: Column(
                                              children: [
                                                _ImageCell(
                                                    url: cafeList[index]
                                                        ["photoUrl"]),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          110,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '회원 닉네임:    ' +
                                                        cafeList[index]
                                                            ["nickname"],
                                                    style: TextStyle(
                                                        //   color: const Color(
                                                        //     0xFF9E9E9E),
                                                        fontSize:
                                                            Adapt.px(25))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                    'About Me : ' +
                                                        cafeList[index]
                                                            ["aboutMe"],
                                                    style: TextStyle(
                                                        //   color: const Color(
                                                        //     0xFF9E9E9E),
                                                        fontSize:
                                                            Adapt.px(25))),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Text(
                                                    '상태 메세지 : ' +
                                                        cafeList[index]
                                                            ["status_mssage"],
                                                    style: TextStyle(
                                                        //   color: const Color(
                                                        //     0xFF9E9E9E),
                                                        fontSize:
                                                            Adapt.px(25))),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            )),
                      )),
            onTap: () {
              (cafeList[index]["cafe_name"] == null)
                  ? Navigator.of(context)
                      .pushNamed('ProfileViewPage', arguments: {
                      'userId': cafeList[index]['id'],
                      'userName': cafeList[index]['nickname'],
                      'photoUrl': cafeList[index]['photoUrl']
                    })
                  : Navigator.of(context).push(PageRouteBuilder(
                      settings: RouteSettings(name: 'bangtalThemaPage'),
                      pageBuilder: (context, animation, secAnimation) {
                        return FadeTransition(
                            opacity: animation,
                            child: Text('xxxxxxxxxxxxxxxxxxxxx'));
                      }));
            },
            /*async {
                var data =  {
                 
                        'document': cafeList[index],
                      }
                    : {
                        'userId': cafeList[index]['id'],
                        'userName': cafeList[index]['nickname'],
                        'photoUrl': cafeList[index]['photoUrl']
                      };
                await Navigator.of(context).push(PageRouteBuilder(
                    settings: RouteSettings(
                        name: (cafeList[index]["cafe_name"] != null)
                            ? 'bangtalThemaPage'
                            : 'ProfileViewPage'),
                    pageBuilder: (context, animation, secAnimation) {
                      return FadeTransition(
                        opacity: animation,
                        child: (cafeList[index]["cafe_name"] != null)
                            ? BangtalThemaPage().buildPage(data)
                            : ProfileViewPage().buildPage(data),
                      );
                    }));
                    */
          );
        });
  }
}
