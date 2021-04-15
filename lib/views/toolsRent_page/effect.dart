import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ToolsRentState> buildEffect() {
  return combineEffects(<Object, Effect<ToolsRentState>>{
    ToolsRentAction.action: _onAction,
  });
}

void _onAction(Action action, Context<ToolsRentState> ctx) {
}
