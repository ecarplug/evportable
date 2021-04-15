import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SavePage extends Page<SaveState, Map<String, dynamic>> {
  SavePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SaveState>(
                adapter: null,
                slots: <String, Dependent<SaveState>>{
                }),
            middleware: <Middleware<SaveState>>[
            ],);

}
