import 'package:ecarplugapp/style/themestyle.dart';
import 'package:ecarplugapp/views/ecarplugFind_page/lib/findDevicesScreen.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'state.dart';

Widget buildView(
    EcarplugFindState state, Dispatch dispatch, ViewService viewService) {
  return MaterialApp(
      debugShowCheckedModeBanner: false, home: FindDevicesScreen(state));
}

// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
