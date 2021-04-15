import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<EcarplugBLEState> buildReducer() {
  return asReducer(
    <Object, Reducer<EcarplugBLEState>>{
      EcarplugBLEAction.action: _onAction,
    },
  );
}

EcarplugBLEState _onAction(EcarplugBLEState state, Action action) {
  final EcarplugBLEState newState = state.clone();
  return newState;
}
