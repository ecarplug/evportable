import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:ecarplugapp/actions/http/tmdb_api.dart';
import 'package:ecarplugapp/models/response_model.dart';
import 'package:ecarplugapp/models/video_list.dart';
import 'action.dart';
import 'state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Effect<EcarplugReportPageState> buildEffect() {
  return combineEffects(<Object, Effect<EcarplugReportPageState>>{
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
    EcarplugReportPageAction.action: _onAction,
    EcarplugReportPageAction.videoCellTapped: _onVideoCellTapped,
    EcarplugReportPageAction.refreshData: _onLoadData,
    EcarplugReportPageAction.mediaTypeChange: _mediaTypeChange,
    EcarplugReportPageAction.filterTap: _filterTap,
    EcarplugReportPageAction.applyFilter: _applyFilter,
  });
}

void _onAction(Action action, Context<EcarplugReportPageState> ctx) {}

Future _onInit(Action action, Context<EcarplugReportPageState> ctx) async {
  ctx.state.scrollController = ScrollController();
  ctx.state.filterState.keyWordController = TextEditingController();
  ctx.state.scrollController.addListener(() async {
    bool isBottom = ctx.state.scrollController.position.pixels ==
        ctx.state.scrollController.position.maxScrollExtent;
    if (isBottom) {
      await _onLoadMore(action, ctx);
    }
  });

  await http.get('http://www.toolsda.com/api/cata/10/item').then((res) {
    if (res.statusCode == 200) {
      ctx.state.itemList = jsonDecode(res.body) as List;
    }
  });

  await _onLoadData(action, ctx);
}

Future _clickFromFirebase(
    Action action, Context<EcarplugReportPageState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoard')
      .orderBy('CDATE', descending: true)
      .limit(10)
      .getDocuments();
  if (r.documents.length > 0) {
    ctx.state.isLoading = false;
    ctx.dispatch(EcarplugReportPageActionCreator.loadFromFirebase(r.documents));
  }
}

Future _loadMore(Context<EcarplugReportPageState> ctx) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  auth.currentUser().then((firebaseUser) async {
    var r = await Firestore.instance
        .collection('chargeTable')
        .document('firebaseUser.uid')
        .collection('chargeData')
        .orderBy('start', descending: true)
        .limit(10)
        .getDocuments();

    if (r.documents.length > 0) {
      ctx.dispatch(
          EcarplugReportPageActionCreator.loadFromFirebase(r.documents));
    }
  });

//  ctx.state.isLoading = false;
  //ctx.dispatch(BangtalboardActionCreator.stopLodingbar());
}

Future _reflash(Action action, Context<EcarplugReportPageState> ctx) async {
  var r = await Firestore.instance
      .collection('bangTalBoard')
      .orderBy('MDATE', descending: true)
      .getDocuments();
  if (r.documents.length > 0) {
    ctx.state.isLoading = false;
    ctx.dispatch(
        EcarplugReportPageActionCreator.reflashFromFirebase(r.documents));
  }
}

void _onDispose(Action action, Context<EcarplugReportPageState> ctx) {
  ctx.state.scrollController.dispose();
  ctx.state.filterState.keyWordController.dispose();
}

Future _onLoadData(Action action, Context<EcarplugReportPageState> ctx) async {
  ctx.dispatch(EcarplugReportPageActionCreator.onBusyChanged(true));
  final _genres = ctx.state.currentGenres;
  var genresIds = _genres.where((e) => e.isSelected).map<int>((e) {
    return e.value;
  }).toList();
  ResponseModel<VideoListModel> r;
  String _sortBy = ctx.state.selectedSort == null
      ? null
      : '${ctx.state.selectedSort.value}${ctx.state.sortDesc ? '.desc' : '.asc'}';
  final _tmdb = TMDBApi.instance;
  if (ctx.state.isMovie)
    r = await _tmdb.getMovieDiscover(
        voteAverageGte: ctx.state.lVote,
        voteAverageLte: ctx.state.rVote,
        sortBy: _sortBy,
        withGenres: genresIds.length > 0 ? genresIds.join(',') : null);
  else
    r = await _tmdb.getTVDiscover(
        voteAverageGte: ctx.state.lVote,
        voteAverageLte: ctx.state.rVote,
        withKeywords: ctx.state.filterState.keyWordController.text,
        sortBy: _sortBy,
        withGenres: genresIds.length > 0 ? genresIds.join(',') : null);
  if (r.success)
    ctx.dispatch(EcarplugReportPageActionCreator.onLoadData(r.result));

  ctx.dispatch(EcarplugReportPageActionCreator.onBusyChanged(false));
  ctx.state.scrollController?.jumpTo(0);
}

Future _onVideoCellTapped(
    Action action, Context<EcarplugReportPageState> ctx) async {
  if (ctx.state.isMovie)
    await Navigator.of(ctx.context).pushNamed(
      'detailpage',
      arguments: {'id': action.payload[0], 'bgpic': action.payload[1]},
    );
  else
    await Navigator.of(ctx.context).pushNamed('tvShowDetailPage', arguments: {
      'id': action.payload[0],
      'bgpic': action.payload[1],
      'posterpic': action.payload[2],
      'name': action.payload[3]
    });
}

Future _onLoadMoreCataItem(
    Action action, Context<EcarplugReportPageState> ctx) async {
  if (ctx.state.isbusy) return;
  ctx.dispatch(EcarplugReportPageActionCreator.onBusyChanged(true));

  final _genres = ctx.state.filterState.currentGenres;
  var genresIds = _genres.where((e) => e.isSelected).map<int>((e) {
    return e.value;
  }).toList();

  ResponseModel<VideoListModel> r;
  String _sortBy = ctx.state.selectedSort == null
      ? null
      : '${ctx.state.selectedSort?.value ?? ''}${ctx.state.filterState.sortDesc ? '.desc' : '.asc'}';

  if (r.success)
    ctx.dispatch(EcarplugReportPageActionCreator.onLoadMore(r.result.results));
  ctx.dispatch(EcarplugReportPageActionCreator.onBusyChanged(false));
}

Future _onLoadMore(Action action, Context<EcarplugReportPageState> ctx) async {
  if (ctx.state.isbusy) return;
  ctx.dispatch(EcarplugReportPageActionCreator.onBusyChanged(true));
  final _genres = ctx.state.filterState.currentGenres;
  var genresIds = _genres.where((e) => e.isSelected).map<int>((e) {
    return e.value;
  }).toList();
  ResponseModel<VideoListModel> r;
  String _sortBy = ctx.state.selectedSort == null
      ? null
      : '${ctx.state.selectedSort?.value ?? ''}${ctx.state.filterState.sortDesc ? '.desc' : '.asc'}';
  final _tmdb = TMDBApi.instance;
  if (ctx.state.isMovie)
    r = await _tmdb.getMovieDiscover(
      voteAverageGte: ctx.state.lVote,
      voteAverageLte: ctx.state.rVote,
      page: ctx.state.videoListModel.page + 1,
      sortBy: _sortBy,
      withGenres: genresIds.length > 0 ? genresIds.join(',') : null,
    );
  else
    r = await _tmdb.getTVDiscover(
        voteAverageGte: ctx.state.lVote,
        voteAverageLte: ctx.state.rVote,
        page: ctx.state.videoListModel.page + 1,
        sortBy: _sortBy,
        withGenres: genresIds.length > 0 ? genresIds.join(',') : null,
        withKeywords: ctx.state.filterState.keywords);
  if (r.success)
    ctx.dispatch(EcarplugReportPageActionCreator.onLoadMore(r.result.results));
  ctx.dispatch(EcarplugReportPageActionCreator.onBusyChanged(false));
}

Future _mediaTypeChange(
    Action action, Context<EcarplugReportPageState> ctx) async {
  final bool _isMovie = action.payload ?? true;
  if (ctx.state.isMovie == _isMovie) return;
  ctx.state.isMovie = _isMovie;
  ctx.state.currentGenres = _isMovie
      ? ctx.state.filterState.movieGenres
      : ctx.state.filterState.tvGenres;
  await _onLoadData(action, ctx);
}

void _filterTap(Action action, Context<EcarplugReportPageState> ctx) async {
  ctx.state.filterState.isMovie = ctx.state.isMovie;
  ctx.state.filterState.selectedSort = ctx.state.selectedSort;
  ctx.state.filterState.currentGenres = ctx.state.currentGenres;
  ctx.state.filterState.lVote = ctx.state.lVote;
  ctx.state.filterState.rVote = ctx.state.rVote;
  Navigator.of(ctx.context)
      .push(PageRouteBuilder(pageBuilder: (_, animation, ___) {
    return SlideTransition(
        position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.ease)),
        child: FadeTransition(
            opacity: animation, child: ctx.buildComponent('filter')));
  }));
}

void _applyFilter(Action action, Context<EcarplugReportPageState> ctx) {
  ctx.state.currentGenres = ctx.state.filterState.currentGenres;
  ctx.state.selectedSort = ctx.state.filterState.selectedSort;
  ctx.state.sortDesc = ctx.state.filterState.sortDesc;
  ctx.state.isMovie = ctx.state.filterState.isMovie;
  ctx.state.lVote = ctx.state.filterState.lVote;
  ctx.state.rVote = ctx.state.filterState.rVote;
  _onLoadData(action, ctx);
}
