import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
//import 'package:lottie/lottie.dart';
import 'package:ecarplugapp/actions/adapt.dart';
import 'package:ecarplugapp/widgets/keepalive_widget.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    StartPageState state, Dispatch dispatch, ViewService viewService) {
  final pages = [
    _FirstPage(
        continueTapped: () => dispatch(StartPageActionCreator.onGoogleSignIn())
        /* state.pageController
          .nextPage(duration: Duration(milliseconds: 400), curve: Curves.ease),*/
        )
  ];

  Widget _buildPage(Widget page) {
    return keepAliveWrapper(page);
  }

  return Scaffold(
    body: FutureBuilder(
        future: _checkContextInit(
          Stream<double>.periodic(Duration(milliseconds: 50),
              (x) => MediaQuery.of(viewService.context).size.height),
        ),
        builder: (_, snapshot) {
          if (snapshot.hasData) if (snapshot.data > 0) {
            Adapt.initContext(viewService.context);
            if (state.isFirstTime != true)
              return Container();
            else
              return PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: state.pageController,
                allowImplicitScrolling: false,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(pages[index]);
                },
              );
          }
          return Container();
        }),
  );
}

Future<double> _checkContextInit(Stream<double> source) async {
  await for (double value in source) {
    if (value > 0) {
      return value;
    }
  }
  return 0.0;
}

class _FirstPage extends StatelessWidget {
  final Function continueTapped;
  const _FirstPage({this.continueTapped});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(height: Adapt.px(400)),
        SizedBox(
            width: Adapt.screenW(),
            height: Adapt.px(200),
            child: Image.asset(
              'assets/icon/launcher_icon.png',
              width: Adapt.px(50),
              height: Adapt.px(50),
              // color: Colors.white,
            )),
        Text(
          'Welcome,',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        SignInButton(
          Buttons.GoogleDark,
          onPressed: continueTapped,
        ),
        SizedBox(height: Adapt.px(20)),
        Text(
          'let start with Google Login',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        Expanded(child: SizedBox()),

        /* Center(
                  child: Text(
                'Continue',
                style: TextStyle(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              )),
            )*/
        SizedBox(height: Adapt.px(20))
      ]),
    ));
  }
}
