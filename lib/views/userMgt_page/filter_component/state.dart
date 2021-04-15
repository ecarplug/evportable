import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/models/enums/genres.dart';
import 'package:ecarplugapp/models/sort_condition.dart';

import '../state.dart';

class FilterState implements Cloneable<FilterState> {
  bool isCharger = true;
  bool sortDesc = true;
  double lVote = 0.0;
  double rVote = 10.0; 
  DateTime startDate=DateTime.now().subtract(Duration(days: 30));
  DateTime endDate=DateTime.now();
  SortCondition selectedSort;
  List<DropdownMenuItem> userList=[];

  String user_nm;
  String user_id;
  var mYear;
  var mMonth;
  TextEditingController keyWordController;
  List<SortCondition> sortTypes = [
    SortCondition(name: 'Name', isSelected: true, value: 'user_nm'),
    SortCondition(name: 'count', isSelected: false, value: 'totalCnt'),
    SortCondition(name: 'Power', isSelected: false, value: 'totalkW'),
  ]; 

  List<SortCondition> movieGenres = new List<SortCondition>();

 
  List<SortCondition> tvGenres = new List<SortCondition>()
    ..addAll(Genres.tvList.keys.map((i) {
      return SortCondition(name: Genres.tvList[i], isSelected: false, value: i);
    }).toList());
  List<SortCondition> currentGenres = [];
  String keywords;

  @override
  FilterState clone() {
    return FilterState()
      ..sortTypes = sortTypes
      ..lVote = lVote
      ..rVote = rVote
      ..user_nm=user_nm
      ..startDate = startDate
      ..endDate = endDate
      ..selectedSort = selectedSort
      ..isCharger = isCharger
      ..sortDesc = sortDesc
      ..movieGenres = movieGenres
      ..tvGenres = tvGenres
      ..keywords = keywords
      ..userList=userList
      ..user_id=user_id
      ..mYear=mYear
      ..mMonth=mMonth
      ..currentGenres = currentGenres
      ..keyWordController = keyWordController;
  }
}

class FilterConnector extends ConnOp<BangtalboardState, FilterState> {
  @override
  FilterState get(BangtalboardState state) {
    final FilterState filterState = state.filterState;
    return filterState;
  }

  @override
  void set(BangtalboardState state, FilterState subState) {
    state.filterState = subState;
    state.lVote = 0.0;
    state.rVote = 10.0;
    state.mMonth=DateTime.now().month; 
    state.mYear=DateTime.now().year; 
  }
}
