import 'package:ecarplugapp/routes/routes.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/widgets.dart' hide Action;
import '../../../views.dart';
import 'action.dart';
import 'state.dart';
import 'package:ecarplugapp/views/views.dart';

Effect<HeaderState> buildEffect() {
  return combineEffects(<Object, Effect<HeaderState>>{
    HeaderAction.action: _onAction,
    HeaderAction.onCellTapped: _onCellTapped,
  });
}

void _onAction(Action action, Context<HeaderState> ctx) {}

Future _onCellTapped(Action action, Context<HeaderState> ctx) async {
  await await Navigator.of(ctx.context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) {
        return Routes.routes.buildPage('mainpage', {
          'pages': List<Widget>.unmodifiable([
              Routes.routes.buildPage('homePage', null),
            Routes.routes.buildPage('ecarplugFindPage', null),
            Routes.routes.buildPage('ecarplugReportPage', null),
            Routes.routes.buildPage('accountPage', null),
       
          ]),
          'page': action.payload[0]
        });
      },
      settings: RouteSettings(name: 'mainpage')));
}
