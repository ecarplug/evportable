import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ToolsRentState> buildReducer() {
  return asReducer(
    <Object, Reducer<ToolsRentState>>{
      ToolsRentAction.action: _onAction,
    },
  );
}

ToolsRentState _onAction(ToolsRentState state, Action action) {
  final ToolsRentState newState = state.clone();
  return newState;
}
