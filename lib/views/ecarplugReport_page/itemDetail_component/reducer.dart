import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ItemDetailState> buildReducer() {
  return asReducer(<Object, Reducer<ItemDetailState>>{
    ItemDetailAction.action: _onAction,
    ItemDetailAction.reflashFromFirebase: _reflashFromFirebase,
  });
}

ItemDetailState _onAction(ItemDetailState state, Action action) {
  final ItemDetailState newState = state.clone();
  return newState;
}

ItemDetailState _reflashFromFirebase(ItemDetailState state, Action action) {
  final List _model = action.payload;
  final ItemDetailState newState = state.clone();
  newState.data = [];
  if (_model != null) {
    newState.data.addAll(_model);
  }

  return newState;
}
