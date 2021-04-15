import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<FavoriteState> buildReducer() {
  return asReducer(
    <Object, Reducer<FavoriteState>>{
      FavoriteAction.action: _onAction,
    },
  );
}

FavoriteState _onAction(FavoriteState state, Action action) {
  final FavoriteState newState = state.clone();
  return newState;
}
