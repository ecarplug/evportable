import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<ToolsShopState> buildEffect() {
  return combineEffects(<Object, Effect<ToolsShopState>>{
    ToolsShopAction.action: _onAction,
  });
}

void _onAction(Action action, Context<ToolsShopState> ctx) {
}
