import 'package:cloud_firestore/cloud_firestore.dart';
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
  final DateTime startDate = action.payload ?? DateTime.now();
  print(startDate); 
  ctx.state.startDate = startDate; 
}

void _onInit(Action action, Context<FilterState> ctx) async {
  ctx.state.currentGenres =
      ctx.state.isCharger ? ctx.state.movieGenres : ctx.state.tvGenres;

     var r;

     

       // ctx.state.userList=[];
        ctx.state.userList=[];
       r= await  Firestore.instance.collectionGroup('users').limit(10).getDocuments();

         r.documents.forEach((data) {
                  ctx.state.userList.add(DropdownMenuItem(
                      // key: Key(element.documentID),
                      child: Text(data['nickname']), 
                      value: data['id'],
                      // key: items[element.documentID],
                    ));
              });
 
       ctx.dispatch(FilterActionCreator.onSelectName(ctx.state.user_id));
    
}
