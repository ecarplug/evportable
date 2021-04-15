import 'package:fish_redux/fish_redux.dart';

class ToolsShopState implements Cloneable<ToolsShopState> {

  @override
  ToolsShopState clone() {
    return ToolsShopState();
  }
}

ToolsShopState initState(Map<String, dynamic> args) {
  return ToolsShopState();
}
