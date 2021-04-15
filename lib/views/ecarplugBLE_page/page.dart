import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EcarplugBLEPage extends Page<EcarplugBLEState, Map<String, dynamic>> {
  EcarplugBLEPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EcarplugBLEState>(
                adapter: null,
                slots: <String, Dependent<EcarplugBLEState>>{
                }),
            middleware: <Middleware<EcarplugBLEState>>[
            ],);

}
