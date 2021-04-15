import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EcarplugFindState> buildReducer() {
  return asReducer(
    <Object, Reducer<EcarplugFindState>>{
      EcarplugFindAction.action: _onAction,
    },
  );
}

EcarplugFindState _onAction(EcarplugFindState state, Action action) {
  final EcarplugFindState newState = state.clone();
  return newState;
}
