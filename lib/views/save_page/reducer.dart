import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<SaveState> buildReducer() {
  return asReducer(
    <Object, Reducer<SaveState>>{
      SaveAction.action: _onAction,
    },
  );
}

SaveState _onAction(SaveState state, Action action) {
  final SaveState newState = state.clone();
  return newState;
}
