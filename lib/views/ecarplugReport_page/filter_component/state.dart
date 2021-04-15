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
  TextEditingController keyWordController;
  List<SortCondition> sortTypes = [
    SortCondition(name: 'Date', isSelected: true, value: 'start'),
    SortCondition(name: 'Area', isSelected: false, value: 'area'),
    SortCondition(name: 'kw', isSelected: false, value: 'kw'),
  ];

  List<SortCondition> movieGenres = new List<SortCondition>();

  /*
  List<SortCondition> movieGenres = new List<SortCondition>()
    ..addAll(Genres.movieList.keys.map((i) {
      return SortCondition(
          name: Genres.movieList[i], isSelected: false, value: i);
    }).toList());
    */
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
      ..startDate = startDate
      ..endDate = endDate
      ..selectedSort = selectedSort
      ..isCharger = isCharger
      ..sortDesc = sortDesc
      ..movieGenres = movieGenres
      ..tvGenres = tvGenres
      ..keywords = keywords
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
  }
}
