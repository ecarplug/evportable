import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ToolsRentPage extends Page<ToolsRentState, Map<String, dynamic>> {
  ToolsRentPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ToolsRentState>(
                adapter: null,
                slots: <String, Dependent<ToolsRentState>>{
                }),
            middleware: <Middleware<ToolsRentState>>[
            ],);

}
