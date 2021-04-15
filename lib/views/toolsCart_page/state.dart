import 'package:fish_redux/fish_redux.dart';

class ToolsCartState implements Cloneable<ToolsCartState> {

  @override
  ToolsCartState clone() {
    return ToolsCartState();
  }
}

ToolsCartState initState(Map<String, dynamic> args) {
  return ToolsCartState();
}
