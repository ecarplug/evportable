import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart' hide Action, Page;
import 'action.dart';
import 'state.dart';

Effect<ItemDetailState> buildEffect() {
  return combineEffects(<Object, Effect<ItemDetailState>>{
    ItemDetailAction.action: _onAction, 
  });
}

void _onAction(Action action, Context<ItemDetailState> ctx) {}
  
