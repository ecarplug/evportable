import 'package:ecarplugapp/actions/user_info_operate.dart';
import 'package:ecarplugapp/views/login_page/effect.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:ecarplugapp/routes/routes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'action.dart';
import 'state.dart';

Effect<StartPageState> buildEffect() {
  return combineEffects(<Object, Effect<StartPageState>>{
    StartPageAction.action: _onAction,
    StartPageAction.onStart: _onStart,
    StartPageAction.onGoogleSignIn: _onGoogleSignIn,
    Lifecycle.build: _onBuild,
    Lifecycle.initState: _onInit,
    Lifecycle.dispose: _onDispose,
  });
}

void _onAction(Action action, Context<StartPageState> ctx) {}
void _onInit(Action action, Context<StartPageState> ctx) async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseMessaging.requestNotificationPermissions();
  _firebaseMessaging.configure();
  _firebaseMessaging.autoInitEnabled();
  ctx.state.pageController = PageController();
  SharedPreferences.getInstance().then((_p) async {
    final _isFirst = _p.getBool('isFirstTime') ?? true;
    if (!_isFirst)
      await _pushToMainPage(ctx.context);
    else
      ctx.dispatch(StartPageActionCreator.setIsFirst(_isFirst));
  });
}

void _onDispose(Action action, Context<StartPageState> ctx) {
  ctx.state.pageController.dispose();
}

void _onBuild(Action action, Context<StartPageState> ctx) {
  // Future.delayed(Duration(milliseconds: 0), () => _pushToMainPage(ctx.context));
}
void _onStart(Action action, Context<StartPageState> ctx) async {
  SharedPreferences.getInstance().then((_p) {
    _p.setBool('isFirstTime', false);
  });
  await _pushToMainPage(ctx.context);
}

Future _pushToMainPage(BuildContext context) async {
  await Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (_, __, ___) {
        return Routes.routes.buildPage('mainpage', {
          'pages': List<Widget>.unmodifiable([
            Routes.routes.buildPage('homePage', null),
            Routes.routes.buildPage('ecarplugFindPage', null),
            Routes.routes.buildPage('ecarplugReportPage', null),
            Routes.routes.buildPage('accountPage', null),
          ])
        });
      },
      settings: RouteSettings(name: 'mainpage')));
}

final FirebaseAuth _auth = FirebaseAuth.instance;

void _onGoogleSignIn(Action action, Context<StartPageState> ctx) async {
  // ctx.state.submitAnimationController.forward();
  try {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null)
      return ctx.state.submitAnimationController.reverse();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    if (user != null) {
      UserInfoOperate.whenLogin(user, user.displayName);
      //Navigator.of(ctx.context).pop({'s': true, 'name': user.displayName});
      ctx.dispatch(StartPageActionCreator.onStart());

      //chatUserAdd(currentUser, SharedPreferences.getInstance());
    } else {
      ctx.state.submitAnimationController.reverse();
      Toast.show("Google signIn fail", ctx.context,
          duration: 3, gravity: Toast.BOTTOM);
    }
  } on Exception catch (e) {
    ctx.state.submitAnimationController.reverse();
    Toast.show(e.toString(), ctx.context, duration: 5, gravity: Toast.BOTTOM);
  }
}
