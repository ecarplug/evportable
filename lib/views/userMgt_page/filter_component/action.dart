import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/models/sort_condition.dart';
import 'package:flutter/foundation.dart';

enum FilterAction {
  action,
  sortChanged,
  genresChanged,
  updateGenres,
  keywordschanged,
  selectName,
  dataSortChange,
  votefilterChange,
  applyFilter,
  dateChange
}

class FilterActionCreator {
  static Action onAction() {
    return const Action(FilterAction.action);
  }

  static Action onSortChanged(SortCondition sort) {
    return Action(FilterAction.sortChanged, payload: sort);
  }

  static Action onGenresChanged(SortCondition genre) {
    return Action(FilterAction.genresChanged, payload: genre);
  }

  static Action onKeyWordsChanged(String s) {
    return Action(FilterAction.keywordschanged, payload: s);
  }

  static Action onSelectName(String userId) {
    return Action(FilterAction.selectName, payload: userId);
  }

  static Action dataSortChange(bool desc) {
    return Action(FilterAction.dataSortChange, payload: desc);
  }

  static Action updateGenres(List<SortCondition> genres) {
    return Action(FilterAction.updateGenres, payload: genres);
  }

  static Action votefilterChange(double lvote, double rvote) {
    return Action(FilterAction.votefilterChange, payload: [lvote, rvote]);
  }

  static Action applyFilter() {
    return const Action(FilterAction.applyFilter);
  }

  static Action dateChange(DateTime s) {
    return Action(FilterAction.dateChange, payload:s);
  }
}
