import 'dart:convert';
import 'dart:typed_data';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'action.dart';
import 'state.dart';

Effect<EcarplugFindState> buildEffect() {
  return combineEffects(<Object, Effect<EcarplugFindState>>{
    EcarplugFindAction.action: _onAction,
    Lifecycle.initState: _onInit,
  });
}

Future<void> _onAction(Action action, Context<EcarplugFindState> ctx) async {}

void _onInit(Action action, Context<EcarplugFindState> ctx) async {
  FlutterBluetoothSerial.instance
      .getBondedDevices()
      .then((List<BluetoothDevice> bondedDevices) {
    // setState(() {
    bondedDevices
        .map((device) => print(device.address + device.name ?? ''))
        .toList();
  });
}
/*
  try {
    String address;
    BluetoothConnection connection =
        await BluetoothConnection.toAddress(address);
    print('Connected to the device');

    connection.input.listen((Uint8List data) {
      print('Data incoming: ${ascii.decode(data)}');
      connection.output.add(data); // Sending data

      if (ascii.decode(data).contains('!')) {
        connection.finish(); // Closing connection
        print('Disconnecting by local host');
      }
    }).onDone(() {
      print('Disconnected by remote request');
    });
  } catch (exception) {
    print('Cannot connect, exception occured');
  }
  */
