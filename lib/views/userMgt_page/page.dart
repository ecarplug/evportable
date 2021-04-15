import 'package:fish_redux/fish_redux.dart';
import 'adapter/adapter.dart';
import 'effect.dart';
import 'filter_component/component.dart';
import 'filter_component/state.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UserMgtPage extends Page<BangtalboardState, Map<String, dynamic>>
    with TickerProviderMixin {
  UserMgtPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BangtalboardState>(
              adapter: NoneConn<BangtalboardState>() + BantalboardAdapter(),
              slots: <String, Dependent<BangtalboardState>>{
                'filter': FilterConnector() + FilterComponent()
              }),
          // middleware: <Middleware<BangtalboardState>>[],
        );
}
