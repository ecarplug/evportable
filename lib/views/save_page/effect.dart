import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<SaveState> buildEffect() {
  return combineEffects(<Object, Effect<SaveState>>{
    SaveAction.action: _onAction,
  });
}

void _onAction(Action action, Context<SaveState> ctx) {
}
