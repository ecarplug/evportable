import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ToolsCartPage extends Page<ToolsCartState, Map<String, dynamic>> {
  ToolsCartPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ToolsCartState>(
                adapter: null,
                slots: <String, Dependent<ToolsCartState>>{
                }),
            middleware: <Middleware<ToolsCartState>>[
            ],);

}
