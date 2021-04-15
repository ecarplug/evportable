import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:ecarplugapp/models/enums/genres.dart';
import 'package:ecarplugapp/models/sort_condition.dart';
import '../action.dart';
import 'action.dart';
import 'state.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Effect<FilterState> buildEffect() {
  return combineEffects(<Object, Effect<FilterState>>{
    FilterAction.action: _onAction,
    FilterAction.genresChanged: _genresChanged,
    FilterAction.applyFilter: _applyFilter,
    FilterAction.dateChange: _dateChange,
    FilterAction.votefilterChange: _votefilterChange,
    Lifecycle.initState: _onInit,
  });
}

void _onAction(Action action, Context<FilterState> ctx) {}

void _genresChanged(Action action, Context<FilterState> ctx) async {
  final _genre = action.payload;
  ctx.state.currentGenres.forEach((e) {
    if (e == _genre) e.isSelected = !e.isSelected;
  });
  ctx.dispatch(FilterActionCreator.updateGenres(ctx.state.currentGenres));
}

void _applyFilter(Action action, Context<FilterState> ctx) {
  ctx.dispatch(BangtalboardActionCreator.applyFilter());
  Navigator.of(ctx.context).pop();
}

void _votefilterChange(Action action, Context<FilterState> ctx) {
  final double _lvote = action.payload[0] ?? 0.0;
  final double _rvote = action.payload[1] ?? 10.0;
  ctx.state.lVote = _lvote;
  ctx.state.rVote = _rvote;
}

void _dateChange(Action action, Context<FilterState> ctx) {
  final DateTime startDate = action.payload[0] ?? DateTime.now();
  final DateTime endDate = action.payload[1] ?? DateTime.now();
  print(startDate);
  print(endDate);
  ctx.state.startDate = startDate;
  ctx.state.endDate = endDate;
}

void _onInit(Action action, Context<FilterState> ctx) async {
  ctx.state.currentGenres =
      ctx.state.isCharger ? ctx.state.movieGenres : ctx.state.tvGenres;

  await http.get('http://www.ecarplugapp.com/api/cata/10').then((res) {
    if (res.statusCode == 200) {
      /*
      ctx.state.drinks = jsonDecode(res.body) as List;
      print(ctx.state.drinks);
      // HERE is the main PROBLEM as mentioned below

      ctx.state.loading = false;
      ctx.dispatch(ToolsRentActionCreator.refresh());
      // Its a list by default though
      */

      List cataList = jsonDecode(res.body) as List;
      cataList.forEach((element) {
        ctx.state.movieGenres.add(SortCondition(
            name: element['ca_name'],
            isSelected: false,
            value: element['ca_id']));
      });

      ctx.dispatch(FilterActionCreator.mediaTypeChange(ctx.state.isCharger));
    } else {
      throw Exception('Cannot load the Album data');
    }
  });
}
