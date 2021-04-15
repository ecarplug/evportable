import 'package:fish_redux/fish_redux.dart';

class ToolsRentState implements Cloneable<ToolsRentState> {

  @override
  ToolsRentState clone() {
    return ToolsRentState();
  }
}

ToolsRentState initState(Map<String, dynamic> args) {
  return ToolsRentState();
}
