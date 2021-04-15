import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<EcarplugBLEState> buildEffect() {
  return combineEffects(<Object, Effect<EcarplugBLEState>>{
    EcarplugBLEAction.action: _onAction,
  });
}

void _onAction(Action action, Context<EcarplugBLEState> ctx) {
}
