import 'package:fish_redux/fish_redux.dart';
import 'components/header_component/component.dart';
import 'components/header_component/state.dart';
import 'components/mainbody_component/component.dart';
import 'components/mainbody_component/state.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class HomePage extends Page<HomePageState, Map<String, dynamic>>
    with TickerProviderMixin {
  HomePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          shouldUpdate: (o, n) {
            return false;
          },
          dependencies: Dependencies<HomePageState>(
              adapter: null,
              slots: <String, Dependent<HomePageState>>{
                'header': HeaderConnector() + HeaderComponent(),
                'popularposter':
                    PopularPosterConnector() + PopularPosterComponent()
              }),
          middleware: <Middleware<HomePageState>>[],
        );
}
