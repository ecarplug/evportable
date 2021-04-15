import 'package:firebase_auth/firebase_auth.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/models/app_user.dart';
import 'package:ecarplugapp/models/sort_condition.dart';
import 'package:ecarplugapp/models/video_list.dart';
import './components/filter_component/state.dart';

import 'components/movicecell_component/state.dart';

class EcarplugReportPageState extends MutableSource
    implements GlobalBaseState, Cloneable<EcarplugReportPageState> {
  FilterState filterState;
  VideoListModel videoListModel;
  ScrollController scrollController;
  GlobalKey stackKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  SortCondition selectedSort;
  bool sortDesc;
  bool isMovie;
  bool isbusy;
  double lVote;
  double rVote;
  bool isLoading = true;
  List itemList = [];
  List data = [];
  List<SortCondition> currentGenres = [];
  AnimationController animationController;
  AnimationController cellAnimationController;
  AnimationController refreshController;
  ScrollController controller;

  @override
  EcarplugReportPageState clone() {
    return EcarplugReportPageState()
      ..filterState = filterState
      ..itemList = itemList
      ..videoListModel = videoListModel
      ..selectedSort = selectedSort
      ..scrollController = scrollController
      ..animationController = animationController
      ..cellAnimationController = cellAnimationController
      ..scaffoldKey = scaffoldKey
      ..stackKey = stackKey
      ..lVote = lVote
      ..rVote = rVote
      ..sortDesc = sortDesc
      ..isMovie = isMovie
      ..isbusy = isbusy
      ..controller = controller
      ..currentGenres = currentGenres;
  }

  @override
  Color themeColor;

  @override
  Locale locale;

  @override
  AppUser user;

  @override
  Object getItemData(int index) => VideoCellState()
    //..videodata = data?.results[index]
    ..item = data[index]
    ..isMovie = isMovie ?? true;

  @override
  String getItemType(int index) => 'moviecell';

//  @override
  // int get itemCount => videoListModel?.results?.length ?? 0;

  @override
  int get itemCount => data?.length ?? 0;

  @override
  void setItemData(int index, Object data) {}
}

EcarplugReportPageState initState(Map<String, dynamic> args) {
  final EcarplugReportPageState state = EcarplugReportPageState();

  state.filterState = new FilterState();
  state.filterState.selectedSort = state.filterState.sortTypes[0];
  state.selectedSort = state.filterState.sortTypes[0];
  state.currentGenres = state.filterState.currentGenres;
  state.scaffoldKey = GlobalKey();
  state.stackKey = GlobalKey();
  state.sortDesc = true;
  state.isMovie = true;
  state.isbusy = false;
  state.lVote = 0.0;
  state.rVote = 10.0;
  state.videoListModel =
      new VideoListModel.fromParams(results: List<VideoListResult>());
  return state;
}
