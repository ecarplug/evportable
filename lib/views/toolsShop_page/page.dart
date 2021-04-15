import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ToolsShopPage extends Page<ToolsShopState, Map<String, dynamic>> {
  ToolsShopPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ToolsShopState>(
                adapter: null,
                slots: <String, Dependent<ToolsShopState>>{
                }),
            middleware: <Middleware<ToolsShopState>>[
            ],);

}
