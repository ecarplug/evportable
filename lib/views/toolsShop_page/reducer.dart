import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ToolsShopState> buildReducer() {
  return asReducer(
    <Object, Reducer<ToolsShopState>>{
      ToolsShopAction.action: _onAction,
    },
  );
}

ToolsShopState _onAction(ToolsShopState state, Action action) {
  final ToolsShopState newState = state.clone();
  return newState;
}
