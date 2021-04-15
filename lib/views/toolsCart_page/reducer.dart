import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ToolsCartState> buildReducer() {
  return asReducer(
    <Object, Reducer<ToolsCartState>>{
      ToolsCartAction.action: _onAction,
    },
  );
}

ToolsCartState _onAction(ToolsCartState state, Action action) {
  final ToolsCartState newState = state.clone();
  return newState;
}
