import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<BangtalboardState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalboardState>>{
      BangtalboardAction.action: _onAction,
      BangtalboardAction.loadFromFirebase: _loadFromFirebase,
      BangtalboardAction.reflashFromFirebase: _reflashFromFirebase,
      BangtalboardAction.stopLodingbar: _stopLodingbar,
    },
  );
}

BangtalboardState _onAction(BangtalboardState state, Action action) {
  final BangtalboardState newState = state.clone();
  return newState;
}

BangtalboardState _loadFromFirebase(BangtalboardState state, Action action) {
  final List _model = action.payload;
  final BangtalboardState newState = state.clone();

  if (_model != null) {
    newState.data.addAll(_model);
  }

  return newState;
}

BangtalboardState _reflashFromFirebase(BangtalboardState state, Action action) {
  final List _model = action.payload;
  final BangtalboardState newState = state.clone();
  newState.data = [];
  if (_model != null) {
    newState.data.addAll(_model);
  }

  return newState;
}

BangtalboardState _stopLodingbar(BangtalboardState state, Action action) {
  final BangtalboardState newState = state.clone();
  // newState.isLoading = false;
  return newState;
}
