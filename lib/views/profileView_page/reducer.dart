import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<ProfileViewState> buildReducer() {
  return asReducer(
    <Object, Reducer<ProfileViewState>>{
      ProfileViewAction.action: _onAction,
      ProfileViewAction.refresh: _refresh,
    },
  );
}

ProfileViewState _onAction(ProfileViewState state, Action action) {
  final ProfileViewState newState = state.clone();
  return newState;
}

ProfileViewState _refresh(ProfileViewState state, Action action) {
  final ProfileViewState newState = state.clone();
  return newState;
}
