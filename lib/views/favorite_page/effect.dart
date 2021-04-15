import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<FavoriteState> buildEffect() {
  return combineEffects(<Object, Effect<FavoriteState>>{
    FavoriteAction.action: _onAction,
  });
}

void _onAction(Action action, Context<FavoriteState> ctx) {
}
