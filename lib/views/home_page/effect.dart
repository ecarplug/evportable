import 'package:ecarplugapp/views/views.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:ecarplugapp/routes/routes.dart';
import 'package:ecarplugapp/widgets/searchbar_delegate.dart';
import 'package:ecarplugapp/models/enums/media_type.dart';
import 'package:ecarplugapp/models/enums/time_window.dart';
import 'action.dart';
import 'state.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'package:google_sign_in/google_sign_in.dart';

Effect<HomePageState> buildEffect() {
  return combineEffects(<Object, Effect<HomePageState>>{
    HomePageAction.action: _onAction,
    HomePageAction.moreTapped: _moreTapped,
    HomePageAction.searchBarTapped: _onSearchBarTapped,
    HomePageAction.cellTapped: _onCellTapped,
    HomePageAction.trendingMore: _trendingMore,
    HomePageAction.onCellTappedThema: _onCellTappedThema,
    HomePageAction.reflash: _reflash,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<HomePageState> ctx) {}

Future _onInit(Action action, Context<HomePageState> ctx) async {
  final Object ticker = ctx.stfState;
  ctx.state.animatedController =
      AnimationController(vsync: ticker, duration: Duration(milliseconds: 600));
  FirebaseAuth auth = FirebaseAuth.instance;
  //state.user.firebaseUser = user;
  auth.currentUser().then((firebaseUser) async {
    ctx.state.userName=firebaseUser.displayName;
    ctx.state.scrollController = new ScrollController();
    final _boardList = await Firestore.instance
        .collection('chargeTable')
        .document(firebaseUser.uid)
        .collection('chargeData')
        .orderBy('start', descending: true)
        .limit(10)
        .getDocuments();

    if (_boardList.documents.length > 0)
      ctx.dispatch(HomePageActionCreator.onInitBoardList(_boardList.documents));
  });
}

void _onDispose(Action action, Context<HomePageState> ctx) {
  ctx.state.animatedController.dispose();
  ctx.state.scrollController.dispose();
}

Future _moreTapped(Action action, Context<HomePageState> ctx) async {
  await Navigator.of(ctx.context).pushNamed('MoreMediaPage',
      arguments: {'list': action.payload[0], 'type': action.payload[1]});
}

Future _onSearchBarTapped(Action action, Context<HomePageState> ctx) async {
  await showSearch(context: ctx.context, delegate: SearchBarDelegate());
}

Future _onCellTapped(Action action, Context<HomePageState> ctx) async {
  final MediaType type = action.payload[4];
  final String id = action.payload[0];
  final String bgpic = action.payload[1];
  final String title = action.payload[2];
  final String posterpic = action.payload[3];
  final String pagename =
      type == MediaType.movie ? 'bangtalThemaPage' : 'tvShowDetailPage';
  var data = {
    'id': id,
    'bgpic': type == MediaType.movie ? posterpic : bgpic,
    'name': title,
    'posterpic': posterpic
  };
  //await Navigator.of(ctx.context).pushNamed(pagename, arguments: data);
}

Future _onCellTappedThema(Action action, Context<HomePageState> ctx) async {
  final DocumentSnapshot document = action.payload[0];
  var data = {
    'document': document,
  };

  //await Navigator.of(ctx.context).pushNamed(pagename, arguments: data);
}

Future _trendingMore(Action action, Context<HomePageState> ctx) async {
  await Navigator.of(ctx.context)
      .push(PageRouteBuilder(pageBuilder: (context, animation, secAnimation) {
    return FadeTransition(
      opacity: animation,
      child:
          Routes.routes.buildPage('trendingPage', {'data': ctx.state.trending}),
    );
  }));
}

Future _reflash(Action action, Context<HomePageState> ctx) async {
  final Object ticker = ctx.stfState;
  ctx.state.animatedController =
      AnimationController(vsync: ticker, duration: Duration(milliseconds: 600));

  ctx.state.scrollController = new ScrollController();
  FirebaseAuth auth = FirebaseAuth.instance;
    auth.currentUser().then((firebaseUser) async {
    ctx.state.scrollController = new ScrollController();
    final _boardList = await Firestore.instance
        .collection('chargeTable')
        .document(firebaseUser.uid)
        .collection('chargeData')
        .orderBy('start', descending: true)
        .limit(10)
        .getDocuments();

    if (_boardList.documents.length > 0)
      ctx.dispatch(HomePageActionCreator.onInitBoardList(_boardList.documents));
  });
}
