import 'package:fish_redux/fish_redux.dart';
import 'package:ecarplugapp/globalbasestate/state.dart';
import 'package:ecarplugapp/globalbasestate/store.dart';
import 'package:ecarplugapp/views/views.dart';

class Routes {
  static final PageRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      'homePage': HomePage(),
      'startPage': StartPage(),
      'mainpage': MainPage(),
      'accountPage': AccountPage(),
      'settingPage': SettingPage(),
      'toolsCartPage': ToolsCartPage(),
      'toolsRentPage': ToolsRentPage(),
      'toolsShopPage': ToolsShopPage(),
      'favaritePage': FavoritePage(),
      'loginPage': LoginPage(),
      'ecarplugFindPage': EcarplugFindPage(),
      'ecarplugBLEPage': EcarplugBLEPage(),
      'ecarplugReportPage': EcarplugReportPage(),
      'userMgtPage' :  UserMgtPage(),
      'ecarplugFilterPage'  : EcarplugRFilterPage()
    },
    visitor: (String path, Page<Object, dynamic> page) {
      if (page.isTypeof<GlobalBaseState>()) {
        page.connectExtraStore<GlobalState>(GlobalStore.store,
            (Object pagestate, GlobalState appState) {
          final GlobalBaseState p = pagestate;
          if (p.themeColor != appState.themeColor ||
              p.locale != appState.locale ||
              p.user != appState.user) {
            if (pagestate is Cloneable) {
              final Object copy = pagestate.clone();
              final GlobalBaseState newState = copy;
              newState.themeColor = appState.themeColor;
              newState.locale = appState.locale;
              newState.user = appState.user;
              return newState;
            }
          }
          return pagestate;
        });
      }
      page.enhancer.append(
        /// View AOP
        viewMiddleware: <ViewMiddleware<dynamic>>[
          safetyView<dynamic>(),
        ],

        /// Adapter AOP
        adapterMiddleware: <AdapterMiddleware<dynamic>>[
          safetyAdapter<dynamic>()
        ],

        /// Effect AOP
        effectMiddleware: [
          _pageAnalyticsMiddleware<dynamic>(),
        ],

        /// Store AOP
        middleware: <Middleware<dynamic>>[
          logMiddleware<dynamic>(tag: page.runtimeType.toString()),
        ],
      );
    },
  );
}

EffectMiddleware<T> _pageAnalyticsMiddleware<T>() {
  return (AbstractLogic<dynamic> logic, Store<T> store) {
    return (Effect<dynamic> effect) {
      return (Action action, Context<dynamic> ctx) {
        if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
          print('${logic.runtimeType} ${action.type.toString()} ');
        }
        return effect?.call(action, ctx);
      };
    };
  };
}
