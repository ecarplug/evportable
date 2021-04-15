import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/models/app_user.dart'; 
import 'package:ecarplugapp/models/sort_condition.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'filter_component/state.dart';
import 'itemDetail_component/state.dart';

class BangtalboardState extends MutableSource
    implements GlobalBaseState, Cloneable<BangtalboardState> {
  List data = [];
  ScrollController controller;
  bool isLoading = false;
  String reload = '';
  GlobalKey<ScaffoldState> scaffoldKey;
  FilterState filterState;
  ScrollController scrollController;
  GlobalKey stackKey;
  bool sortDesc;
  bool isCharger;
  bool isbusy;
  double lVote;
  double rVote;
  DateTime startDate=DateTime.now().subtract(Duration(days: 30));
  DateTime endDate=DateTime.now();
  List itemList = [];
  AnimationController animationController;
  AnimationController cellAnimationController;
  AnimationController refreshController;
  List<SortCondition> currentGenres = [];
  SortCondition selectedSort;
  double totalTime;
  String totalTimeText;
  double totalpwr;
  String user_nm,user_id;
  double totalkW=0.0;
  int totalCnt=0;
  var mYear;
  var mMonth;

  @override
  BangtalboardState clone() {
    return BangtalboardState()
      ..data = data
      ..controller = controller
      ..animationController = animationController
      ..refreshController = refreshController
      ..user = user
      ..sortDesc = sortDesc
      ..isCharger = isCharger
      ..isbusy = isbusy
      ..filterState = filterState
      ..currentGenres = currentGenres
      ..selectedSort = selectedSort
      ..scrollController = scrollController
      ..scaffoldKey = scaffoldKey
      ..stackKey = stackKey
      ..lVote = lVote
      ..rVote = rVote
      ..user_nm=user_nm
      ..user_id=user_id
      ..mMonth=mMonth
      ..mYear=mYear
      ..startDate =startDate
      ..endDate=endDate
      ..totalTime=totalTime
      ..totalTimeText=totalTimeText
      ..totalpwr=totalpwr
      ..totalkW=totalkW
      ..totalCnt=totalCnt
      ..cellAnimationController = cellAnimationController;
  }

  @override
  Object getItemData(int index) => ItemDetailState(
        itemDetailData: data[index],
        index: index,
        nickname: data[index]['deviceId'],
        cellAnimationController: cellAnimationController,
        animationController: animationController,
      );

  @override
  String getItemType(int index) => 'detail';

  @override
  void setItemData(int index, Object data) {
    // TODO: implement setItemData
  }

  @override
  int get itemCount => data.length ?? 0;

  @override
  Locale locale;

  @override
  Color themeColor;

  @override
  AppUser user;
}

BangtalboardState initState(Map<String, dynamic> args) {
  BangtalboardState state = BangtalboardState();
  state.reload = args != null ? args['reload'] : null;

  state.filterState = new FilterState();
  state.filterState.selectedSort = state.filterState.sortTypes[0];
  state.selectedSort = state.filterState.sortTypes[0];
  state.currentGenres = state.filterState.currentGenres; 
  state.startDate = state.filterState.startDate;   
  state.endDate = state.filterState.endDate;   
  state.user_id = state.filterState.user_id;   
  state.user_nm = state.filterState.user_nm;  
  state.mYear=DateTime.now().year;
  state.mMonth=DateTime.now().month;
  state.scaffoldKey = GlobalKey();
  state.stackKey = GlobalKey();
  state.sortDesc = true;
  state.isCharger = false;
  state.isbusy = false; 
  state.lVote = 0.0;
  state.rVote = 10.0;
  state.totalpwr=0;
  state.totalTime=0;
  state.totalTimeText=""; 
 

  return state;
}
