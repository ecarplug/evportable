import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum ToolsShopAction { action }

class ToolsShopActionCreator {
  static Action onAction() {
    return const Action(ToolsShopAction.action);
  }
}
