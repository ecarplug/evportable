import 'package:fish_redux/fish_redux.dart';

import 'adapter.dart';
import 'components/filter_component/component.dart';
import 'components/filter_component/state.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class EcarplugRFilterPage
    extends Page<EcarplugReportPageState, Map<String, dynamic>> {
  EcarplugRFilterPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          shouldUpdate: (o, n) {
            return o.filterState.isMovie != n.filterState.isMovie ||
                o.videoListModel != n.videoListModel ||
                o.isbusy != n.isbusy;
          },
          view: buildView,
          dependencies: Dependencies<EcarplugReportPageState>(
              adapter:
                  NoneConn<EcarplugReportPageState>() + DiscoverListAdapter(),
              slots: <String, Dependent<EcarplugReportPageState>>{
                'filter': FilterConnector() + FilterComponent()
              }),
          middleware: <Middleware<EcarplugReportPageState>>[],
        );
}
