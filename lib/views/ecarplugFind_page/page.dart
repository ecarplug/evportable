import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EcarplugFindPage extends Page<EcarplugFindState, Map<String, dynamic>> {
  EcarplugFindPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EcarplugFindState>(
                adapter: null,
                slots: <String, Dependent<EcarplugFindState>>{
                }),
            middleware: <Middleware<EcarplugFindState>>[
            ],);

}
