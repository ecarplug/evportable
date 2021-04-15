import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ProfileViewPage extends Page<ProfileViewState, Map<String, dynamic>> {
  ProfileViewPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ProfileViewState>(
              adapter: null, slots: <String, Dependent<ProfileViewState>>{}),
          middleware: <Middleware<ProfileViewState>>[],
        );
}
