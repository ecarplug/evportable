import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import '../state.dart';

Reducer<BangtalboardState> buildReducer() {
  return asReducer(
    <Object, Reducer<BangtalboardState>>{
      AdapterAction.action: _onAction,
    },
  );
}

BangtalboardState _onAction(BangtalboardState state, Action action) {
  final BangtalboardState newState = state.clone();
  return newState;
}
