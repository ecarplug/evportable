import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:ecarplugapp/models/enums/genres.dart';
import 'package:ecarplugapp/models/sort_condition.dart';
import '../../state.dart';

class FilterState implements Cloneable<FilterState> {
  bool isMovie = true;
  bool sortDesc = true;
  double lVote = 0.0;
  double rVote = 10.0;
  SortCondition selectedSort;
  TextEditingController keyWordController;
  List<SortCondition> sortTypes = [
    SortCondition(name: 'Popularity', isSelected: true, value: 'popularity'),
    SortCondition(
        name: 'Release Date', isSelected: false, value: 'release_date'),
    SortCondition(name: 'Title', isSelected: false, value: 'original_title'),
    SortCondition(name: 'Rating', isSelected: false, value: 'vote_average'),
    SortCondition(name: 'Vote Count', isSelected: false, value: 'vote_count'),
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
      ..selectedSort = selectedSort
      ..isMovie = isMovie
      ..sortDesc = sortDesc
      ..movieGenres = movieGenres
      ..tvGenres = tvGenres
      ..keywords = keywords
      ..currentGenres = currentGenres
      ..keyWordController = keyWordController;
  }
}

class FilterConnector extends ConnOp<EcarplugReportPageState, FilterState> {
  @override
  FilterState get(EcarplugReportPageState state) {
    final FilterState filterState = state.filterState;
    return filterState;
  }

  @override
  void set(EcarplugReportPageState state, FilterState subState) {
    state.filterState = subState;
  }
}
