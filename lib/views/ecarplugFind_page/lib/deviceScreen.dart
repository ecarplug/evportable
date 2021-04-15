import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'dart:async';

import '../state.dart';
import 'bltLib.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

BluetoothCharacteristic notifyCharacteristic;
BluetoothDevice _device;

BluetoothCharacteristic writeCharacteristic;

StreamSubscription _stateSubscription;
StreamSubscription _mtuSubscription;
StreamSubscription _servicesSubscription;
StreamSubscription _notifySubscription;
StreamSubscription _notifySubscriptionDesc;
BluetoothCharacteristic notichar;
BluetoothDescriptor descriptor;

class DeviceScreen extends StatefulWidget {
  const DeviceScreen({Key key, this.device, this.state}) : super(key: key);
  final BluetoothDevice device;
  final EcarplugFindState state;
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

List<BluetoothService> services;

BluetoothCharacteristic c2;
BluetoothCharacteristic c1;
String charged_time = "-";
String total_power = "-";
String status ="-";
bool isstart = false;
bool isEnd = false;
var a_current = "";
var maskFormatter =
    new MaskTextInputFormatter(mask: '#:##', filter: {"#": RegExp(r'[0-9]')});
var startChargeTEXT = "START CHARGE";
Future<void> disconnect(_device) {
  return _device.disconnect().then((value) => _clearResources());
}

Future<void> _clearResources() async {
  // await _mtuSubscription.cancel();
  //_mtuSubscription = null;

  await _notifySubscriptionDesc.cancel();
  _notifySubscriptionDesc = null;
  await _servicesSubscription.cancel();
  _servicesSubscription = null;
  await _notifySubscription.cancel();
  _notifySubscription = null;
  //notifyChannel = null;
  //WwriteChannel = null;
}

bool boo = false;
bool isChargeing = false;

class _DeviceScreenState extends State<DeviceScreen> {
  SharedPreferences prefs;
  String docId = "";
  @override
  initState() {
    sharedPrefs();
    //final mtu = await widget.device.mtu.first;
    // setC(widget);
    _clearResources();
    connect(widget.device).then((value) {
      Timer.periodic(Duration(seconds: 10), (timer) {
        //heartbeat(widget);
        getChargedTime(widget);
         
      //  getAllInfo(widget);
        //getWaitingTime(widget);

        print(boo);

        //   get Power(widget);
      });
    });
    super.initState();
  }

  Future<void> sharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    docId = prefs.getString("docId") ?? "";

    isChargeing = prefs.getBool("isChargeing") ?? false;
    if (isChargeing) {
      setState(() {
        starEndText = "END CHARGE";
        starEndcolor = Colors.green;
      });
    }
  }

  @override
  void dispose() {
    //  disconnect(widget.device);
    super.dispose();
  }

  final _textController = TextEditingController();
  void _handleSubmitted(String text) {
    _textController.clear();
  }

  List<bool> _selections = [false, false, false];
  String starEndText = "START CHARGE";
  // String total_power = 'START CHARGE';
  Color starEndcolor = Colors.blue[900];
  String starEnd = 's';

  final int INITIAL_VALUE = 65535;
  int POLYNOMIAL = 40961;
  @override
  Widget build(BuildContext context) {
    // var isSelected;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ID:' + widget.device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () => widget.device.disconnect().then((value) {
                        noti = false;
                        _clearResources();
                      });
                  text = 'Connected';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => widget.device.connect();
                  //.then((value) => connect(widget.device));
                  text = 'Connect';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothDeviceState>(
              stream: widget.device.state,
              initialData: BluetoothDeviceState.connecting,
              builder: (c, snapshot) => Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: (snapshot.data == BluetoothDeviceState.connected)
                          ? Icon(Icons.bluetooth_connected)
                          : Icon(Icons.bluetooth_disabled),
                      title: Text('ID:' + widget.device.name
                          //'Device is ${snapshot.data.toString().split('.')[1]}.'
                          ),
                      subtitle: Text('${widget.device.id}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton.icon(
                          textColor: Colors.white,
                          color: Colors.blue[700],
                          onPressed: () {
                            connect(widget.device);
                          },
                          icon: Icon(Icons.refresh, size: 18),
                          label: Text("Reconnect"),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            /*
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device.services,
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
            */
            SizedBox(
              height: 30,
            ),
            CustomToggleButtons(
              children: <Widget>[
                mainIcon('16A', Icons.power),
                mainIcon('10A', Icons.power),
                mainIcon('6A', Icons.power),
              ],
              isSelected: _selections,
              onPressed: (int index) {
                setState(() {
                  _selections = [false, false, false];
                  _selections[index] = true;
                  print(_selections[index]);
                  if (index == 0) setChargeAmp(widget, 16);
                  if (index == 1) setChargeAmp(widget, 10);
                  if (index == 2) setChargeAmp(widget, 6);
                });
              },
              spacing: 10,
              color: Colors.grey,
              disabledColor: Colors.grey,
              selectedColor: Colors.white,
              fillColor: Colors.blueAccent,
              // renderBorder: false,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Charged Time : ' + charged_time,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Total Power : ' + total_power + " Kw",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
              Text(
              'Status : ' + status  ,
              style: TextStyle(fontSize: 15),
            ),
             
            SizedBox(
              height: 10,
            ),
            RaisedButton.icon(
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              textColor: Colors.white,
              disabledTextColor: Colors.grey,
              color: starEndcolor,
              onPressed: () {
                if (starEndText == startChargeTEXT) {
                  setState(() {
                    setStartCharge(widget);
                    //  starEndcolor = Colors.blue[900];
                  });
                } else {
                  setState(() {
                    setStopCharge(widget);
                    //    starEndcolor = Colors.green;
                  });
                }

                // Respond to button press
              },
              icon: Icon(Icons.check, size: 25),
              label: Text(
                starEndText,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            /*
            RaisedButton.icon(
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              textColor: Colors.white,
              disabledTextColor: Colors.grey,
              color: starEndcolor,
              onPressed: () {
                getChargedTime(widget);

                // Respond to button press
              },
              icon: Icon(Icons.check, size: 25),
              label: Text(
                'getChargedTime',
                style: TextStyle(fontSize: 20),
              ),
            )
            */

            Row(children: <Widget>[
              SizedBox(width: 30),
              Text('Delay Time : '),
              SizedBox(width: 5),
              Flexible(
                child: TextField(
                  inputFormatters: [maskFormatter],
                  // inputFormatters: [
                  //  LengthLimitingTextInputFormatter(2),
                  // ],
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'hr:min(Max:9hr)',
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(8), // Added this
                  ),

                  //  new InputDecoration.collapsed(hintText: "0"),
                ),
              ),
              //   Text('hour'),
              SizedBox(width: 10),
              RaisedButton.icon(
                padding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textColor: Colors.white,
                disabledTextColor: Colors.grey,
                color: starEndcolor,
                onPressed: () {
                  setDelayTime(widget);

                  // Respond to button press
                },
                icon: Icon(Icons.check, size: 15),
                label: Text(
                  'DELAY',
                  style: TextStyle(fontSize: 15),
                ),
              ),
             
            ]),
          ],
        ),
      ),
    );
  }

  void setChargeAmp(widget, amp) async {
    //Updating characteristic to perform write operation.
    //setC(widget);
    var aaa = [165, 1, 1, 84, 1, int.parse("10", radix: amp)];
    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int x, y;
    if (fromHex(getCRC(aaa)).length > 1) {
      x = fromHex(getCRC(aaa))[1];
    } else {
      x = 0;
    }
    y = fromHex(getCRC(aaa))[0];

    List<int> aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], aaa[5], x, y];
    sendValue(aaa2);

    //  await c.read();
  }

  void setStartCharge(widget) async {
    //Updating characteristic to perform write operation.

    var aaa = [165, 1, 0, 80, 2, 255, 255];

    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], aaa[5], aaa[6], y, x];
    sendValue(aaa2);
  }

  void setStopCharge(widget) async {
    // setC(widget);

    //checking each services provided by device
    //setRead(widget);

    var aaa = [165, 1, 0, 82, 0];

    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];
    sendValue(aaa2);
  }

/*
  void getchargeTime(widget) async {
    var aaa = [165, 1, 0, 52, 0];

    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];
    sendValue(aaa2);
  }
*/

  var islisten = false;
  void getCurrentPreData(widget) async {
    var aaa = [165, 1, 0, 50, 0];

    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];

    sendValue(aaa2);
  }

  void getPower(widget) async {
    int code = 22;
    var aaa = [165, 1, 0, code, 0];

    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];

    sendValue(aaa2);
    // c.write(aaa2);
  }

  void getVolt(widget) async {
    //Updating characteristic to perform write operation.
    int code = 20;
    var aaa = [165, 1, 0, code, 0];

    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];

    sendValue(aaa2);
    // c.write(aaa2);
  }

  void getCurrent(widget) async {
    int code = 18;
    var aaa = [165, 1, 0, code, 0];

    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];
    sendValue(aaa2);
    // c.write(aaa2);
  }

  void getAllInfo(widget) async {
    //Updating characteristic to perform write operation.
    int code = 46;
    var aaa = [165, 1, 0, code, 0];
    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);

    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];
    //  aaa2 = [0xA5, 0x04, 0x00, 0x2E, 0x00, y, x];

    sendValue(aaa2);

    //await c2.setNotifyValue(!c2.isNotifying);
    //await c2.read();
    // var characteristics = service.characteristics;
    //});
  }

  void getChargedTime(widget) async {
    //setC(widget);
    int code = 52;
    var aaa = [165, 1, 0, code, 0];
    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];
    //  aaa2 = [0xA5, 0x04, 0x00, 0x2E, 0x00, y, x];

    sendValue(aaa2);
  }

  void getEnergy(widget) async {
    //setC(widget);
    int code = 24;
    var aaa = [165, 1, 0, code, 0];
    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];
    //  aaa2 = [0xA5, 0x04, 0x00, 0x2E, 0x00, y, x];

    sendValue(aaa2);
  }

  void setDelayTime(widget) async {
    int x, y;
    int code = 88;
    var aaa = [165, 1, 0, code, 2, 10, 0];
    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    aaa[3] = 88;
    aaa[4] = 2;
    aaa[5] = 0;
    aaa[6] = 0;
    print("===============");
    // var delayTime = "7200";
    // delayTime=_textController.text;
    var delayTime = 0;
    if (_textController.text.split(":").length == 2) {
      delayTime = int.parse(_textController.text.split(":")[0]) * 3600 +
          int.parse(_textController.text.split(":")[1]) * 60;
    } else {
      delayTime = int.parse(_textController.text) * 3600;
    }

    print((delayTime).toRadixString(16));
    var len = (delayTime).toRadixString(16).length;
    var dtime = (delayTime).toRadixString(16);
    if (len < 3) {
      aaa[5] = int.parse(dtime, radix: 16);
    } else {
      aaa[6] = int.parse(dtime.substring(0, dtime.length - 2), radix: 16);
      aaa[5] =
          int.parse(dtime.substring(dtime.length - 2, dtime.length), radix: 16);
    }

    print(aaa);

    if (fromHex(getCRC(aaa)).length > 1) {
      x = fromHex(getCRC(aaa))[1];
    } else {
      x = 0;
    }
    y = fromHex(getCRC(aaa))[0];

    sendValue([aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], aaa[5], aaa[6], x, y]);
    print(
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    print(aaa);
  }

  void heartbeat(widget) {
    int code = 0xF0;
    var aaa = [165, 1, 0, code, 0];
    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);

    print(
        "===============heartbeatheartbeatheartbeatheartbeatheartbeatheartbeatheartbeatheartbeatheartbeatheartbeat");

    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    sendValue([aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x]);
  }

  void getWaitingTime(widget) async {
    //setC(widget);
    int code = 56;
    var aaa = [165, 1, 0, code, 0];
    aaa[1] = new Random().nextInt(16);
    aaa[2] = new Random().nextInt(16);
    int res = 65535;
    aaa.forEach((data) {
      res ^= data;
      for (int i = 0; i < 8; i++) {
        res = (res & 1) == 1 ? (res >> 1) ^ 40961 : res >> 1;
      }
    });

    int x = (65280 & res) >> 8;
    int y = res & 255;

    var aaa2 = [aaa[0], aaa[1], aaa[2], aaa[3], aaa[4], y, x];
    //  aaa2 = [0xA5, 0x04, 0x00, 0x2E, 0x00, y, x];

    sendValue(aaa2);
  }

  var noti = true;
  Future<void> sendValue(List<int> data) async {
    _stateSubscription = _device.state.listen((state) async {
      if (state == BluetoothDeviceState.disconnected) {
        await _stateSubscription.cancel();
        _stateSubscription = null;
        noti = false;
        return;
      }

      if (state == BluetoothDeviceState.connected) {
        try {
          await writeCharacteristic.write(data, withoutResponse: true);

          //     if (noti) {
          //   notifyCharacteristic
          //       .setNotifyValue(!notifyCharacteristic.isNotifying);
          noti = false;
          //   }

          notifyCharacteristic.setNotifyValue(true);
        } on PlatformException {
          /*
    await Future.delayed(Duration(milliseconds: 100));
    _device.disconnect().then((value) {
      _mtuSubscription = null;
      _servicesSubscription = null;
      _notifySubscription = null;
    }).then((value) => _device.connect().then((value) {
          connect(_device);
        }));
    noti = true;
    */
        }
      }
    });
  }

  var xxxxi = 0;
  var firstValue = [0, 0, 0];
  Future<void> connect(BluetoothDevice device) async {
    await Future.delayed(Duration(milliseconds: 2000));

    // await _device.connect(autoConnect: false);
    _device = device;
    _stateSubscription = _device.state.listen((state) async {
      if (state == BluetoothDeviceState.disconnected) {
        await _stateSubscription.cancel();
        _stateSubscription = null;
      }

      if (state == BluetoothDeviceState.connected) {
        //   _mtuSubscription = _device.mtu.listen((mtu) async {
        //      await notifyCharacteristic.setNotifyValue(true);
        //    });
        if (_servicesSubscription != null) {
          _servicesSubscription.cancel();
          _servicesSubscription = null;
        }

        _servicesSubscription = _device.services.listen((services) async {
          var service = services.firstWhere((element) =>
              element.uuid.toString() ==
              "0000a002-0000-1000-8000-00805f9b34fb");

          notifyCharacteristic = service.characteristics.firstWhere((c) =>
              c.uuid.toString() == "0000c306-0000-1000-8000-00805f9b34fb");
          if (_notifySubscriptionDesc != null) {
            _notifySubscriptionDesc.cancel();
            _notifySubscriptionDesc = null;
          }

          _notifySubscriptionDesc = notifyCharacteristic.descriptors
              .firstWhere((c) =>
                  c.uuid.toString() == "00002902-0000-1000-8000-00805f9b34fb")
              .value
              .listen((event) {});
          if (_notifySubscription != null) {
            _notifySubscription.cancel();
            _notifySubscription = null;
          }
          _notifySubscription = notifyCharacteristic.value.listen((value) {
            if (firstValue[0] == value[0] &&
                firstValue[1] == value[1] &&
                firstValue[2] == value[2]) {
              print("중복");
            } else {
              print(value);

              print(xxxxi);
              xxxxi = xxxxi + 1;

              getReadDATA(value);
              firstValue[0] = value[0];
              firstValue[1] = value[1];
              firstValue[2] = value[2];
            }

            //Proceed with data...
          });

          writeCharacteristic = service.characteristics.firstWhere((c) =>
              c.uuid.toString() == "0000c304-0000-1000-8000-00805f9b34fb");

          _device.requestMtu(200);
        });
        // notifyCharacteristic.setNotifyValue(!notifyCharacteristic.isNotifying);
        _device.discoverServices();
      }
    });
  }

// [165, 13, 3, 85, 2, 128, 0, 122, 219]

  int chargedSec = 0;

  void getReadDATA(List<int> value) async {
    print(
        "valuevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevalue");
    print(value);

/*Status Code	Description 
0x80	PEVC ready，but not connected to EV
0x81	PEVC connected to EV, but waiting-time is not 0
0x82	PEVC connected to EV, charging
0x83	PEVC connected to EV,but charging over。
0x8F（1）	PEVC error,not ready
*/ 
       switch (value[5]) {
         case 0x80:
         setState(() {
            status= "PEVC ready，but not connected to EV";
         });
         break;

        case 0x81:
           setState(() {
            status= "PEVC connected to EV, but waiting-time is not 0";
         });
          break;

         case 0x82:
         setState(() {
            status= "PEVC connected to EV, charging";
         });
          break;
        case 0x83:
         setState(() {
            status= "PEVC connected to EV,but charging over。";
         });
          break;

        case 0x84:
           setState(() {
            status= "PEVC error,not ready";
         });
         break;

       }



    print(
        "valuevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevaluevalue");
    switch (value[3]) {
      case 23: /*23 power */
        var de_power = ((((((((value[6] & ByteUtils.BYTE_MAX) +
                                ((value[7] & ByteUtils.BYTE_MAX) * 256)) +
                            (value[8] & ByteUtils.BYTE_MAX)) +
                        ((value[9] & ByteUtils.BYTE_MAX) * 256)) +
                    (value[10] & ByteUtils.BYTE_MAX)) +
                ((value[11] & ByteUtils.BYTE_MAX) * 256))) *
            0.01);
        //    DebugBt.this.total_power.setText(DebugBt.this.de_power);
        //   DebugBt.this.power_a = DebugBt.df2.format(((double) ((value[6] & ByteUtils.BYTE_MAX) + ((value[7] & ByteUtils.BYTE_MAX) * 256))) * 0.01d) + "kW";
        //    DebugBt.this.power_b = DebugBt.df2.format(((double) ((value[8] & ByteUtils.BYTE_MAX) + ((value[9] & ByteUtils.BYTE_MAX) * 256))) * 0.01d) + "kW";
        //    DebugBt.this.power_c = DebugBt.df2.format(((double) ((value[10] & ByteUtils.BYTE_MAX) + ((value[11] & ByteUtils.BYTE_MAX) * 256))) * 0.01d) + "kW";
        //    DebugBt.this.a_power.setText(DebugBt.this.power_a);
        //   DebugBt.this.b_power.setText(DebugBt.this.power_b);
        //   DebugBt.this.c_power.setText(DebugBt.this.power_c);
        print("de_power============================================>de_power");
        print(de_power);
        break;
      case 25: /*23 power */
        var get_energy = ((value[6] & ByteUtils.BYTE_MAX) +
                ((value[7] & ByteUtils.BYTE_MAX) * 256)) *
            0.01; 
        print(get_energy.toString() + "kW");

         setState(() {
               total_power = (get_energy ?? 0.00).toString() + "kW";
            
            });



        if (isstart) { 
          Firestore.instance
              .collection('chargeTable')
              .document(widget.state.user.firebaseUser.uid)
              .collection('chargeData')
              .document(docId)
              .updateData(
                  {'end': DateTime.now(), 'start_get_energy': get_energy});

                  setState(() {
                        charged_time = DateTime.now().toString().substring(0, 10);
                         charged_time = "00:00:00";
                  });
        prefs.setDouble("get_energy", get_energy);
          isstart = false;
        }  
        
         if (isEnd) {
          var mYear=DateTime.now().year;
          var mMonth=DateTime.now().month;
          Firestore.instance
              .collection('chargeTable')
              .document(widget.state.user.firebaseUser.uid)
              .collection('chargeData')
              .document(docId)
              .updateData({
            'end': DateTime.now(),
            'm_year': mYear,
            'm_month': mMonth,
            'get_energy': (get_energy-prefs.getDouble("get_energy") ),
            'end_get_energy': get_energy,
          });
          isEnd = false;
          // 월별 사용량 업데이트 
           upDateTotalkW(get_energy-prefs.getDouble("get_energy") ,mYear,mMonth);




       //   isstart=true;
        }

        break;

      case 47: /*47 get all data */
        var voltage_a = (value[12] & ByteUtils.BYTE_MAX).toString() +
            ((value[13] & ByteUtils.BYTE_MAX) * 256).toString();

        print("voltage_a=" + voltage_a);

        var intTotalPower = ((((((((value[18] & ByteUtils.BYTE_MAX) +
                                ((value[19] & ByteUtils.BYTE_MAX) * 256)) +
                            (value[20] & ByteUtils.BYTE_MAX)) +
                        ((value[21] & ByteUtils.BYTE_MAX) * 256)) +
                    (value[22] & ByteUtils.BYTE_MAX)) +
                ((value[23] & ByteUtils.BYTE_MAX) * 256))) *
            0.01);

        print("total_power=" + intTotalPower.toString());
        var aCurrent = ((value[6] & ByteUtils.BYTE_MAX) +
                ((value[7] & ByteUtils.BYTE_MAX) * 256)) *
            0.1;
        print(aCurrent.toString() + "A");
        var ontime_current, voltage = "";

        if (isThree_phase_voltage(
            (value[12] & ByteUtils.BYTE_MAX) +
                ((value[13] & ByteUtils.BYTE_MAX) * 256),
            (value[14] & ByteUtils.BYTE_MAX) +
                ((value[15] & ByteUtils.BYTE_MAX) * 256),
            (value[16] & ByteUtils.BYTE_MAX) +
                ((value[17] & ByteUtils.BYTE_MAX) * 256))) {
          ontime_current = ((((((((value[6] & ByteUtils.BYTE_MAX) +
                                          ((value[7] & ByteUtils.BYTE_MAX) *
                                              256)) +
                                      (value[8] & ByteUtils.BYTE_MAX)) +
                                  ((value[9] & ByteUtils.BYTE_MAX) * 256)) +
                              (value[10] & ByteUtils.BYTE_MAX)) +
                          ((value[11] & ByteUtils.BYTE_MAX) * 256)) /
                      3) *
                  0.1)
              .toString();
          voltage = (((value[12] & ByteUtils.BYTE_MAX) +
                          ((value[13] & ByteUtils.BYTE_MAX) * 256))
                      .round() *
                  1.732)
              .toString();
        } else {
          ontime_current = ((((value[6] & ByteUtils.BYTE_MAX) +
                      ((value[7] & ByteUtils.BYTE_MAX) * 256))) *
                  0.1)
              .toString();
        }

            
 
        break;

      case 53: /*53 chargedSec */

       chargedSec = (value[6] & ByteUtils.BYTE_MAX) +
            (value[7] & ByteUtils.BYTE_MAX) * 256;


  
        if (isstart) {  
          prefs.setInt("chargedSec", chargedSec);
           }  
        
         if (isEnd) {
       
          } 

        
        chargedSec=  chargedSec-(prefs.getInt("chargedSec")??0);
          




        chargedSec = (value[6] & ByteUtils.BYTE_MAX) +
            (value[7] & ByteUtils.BYTE_MAX) * 256;

        print(
            "============================================================================================================chargedSec");
        print(chargedSec);
        //double chargedSectint = chargedSec;

        int hour = (chargedSec / 3600).floor();
        String h = "00";
        if (hour < 10)
          h = "0" + hour.toString();
        else
          h = hour.toString();
        int min = ((chargedSec - hour * 3600) / 60).floor();
        String m = "00";
        if (min < 10)
          m = "0" + min.toString();
        else
          m = min.toString();
        int sec = chargedSec % 60;
        String s = "00";

        if (sec < 10)
          s = "0" + sec.toString();
        else
          s = sec.toString();

        setState(() {
          charged_time = h + ":" + m + ":" + s;

          print(charged_time);
        });
        docId = prefs.getString("docId");
        Firestore.instance
            .collection('chargeTable')
            .document(widget.state.user.firebaseUser.uid)
            .collection('chargeData')
            .document(docId)
            .updateData({
          'charged_time': charged_time,
          'chargedSec': chargedSec,
        }).then((value) {
          print("call back ================> UPDATE 충전시간");
        });
        getEnergy(widget);
        break;

      case 57: /*53 waiting Time */

        var waiting_time = ((value[6] & ByteUtils.BYTE_MAX) +
                    ((value[7] & ByteUtils.BYTE_MAX) * 256))
                .toString() +
            "s";

        print(waiting_time);
        setState(() {
          //_textController.text=waiting_time;
        });

        break;

      case 81: /*81  START CHARGE */

        if (value[6] == 0) {
          isstart=true;
          Fluttertoast.showToast(msg: "Start Charge");
          Firestore.instance
              .collection('chargeTable')
              .document(widget.state.user.firebaseUser.uid)
              .collection('chargeData')
              .add({
            'user_id': widget.state.user.firebaseUser.uid,
            'user_nm': widget.state.user.firebaseUser.displayName,
            'deviceName': widget.device.name,
            'deviceId': widget.device.id.toString(),
            'start': DateTime.now(),
            'end': DateTime.now(),
            'm_year': DateTime.now().year,
            'm_date': DateTime.now().month,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          }).then((value) {
            docId = value.documentID;
            prefs.setString("docId", docId);
            prefs.setBool("isChargeing", true);

            print("call back ================> START CHARGE");
            setState(() {
              starEndText = "END CHARGE";

              starEndcolor = Colors.green;
            });
          });
        } else if (value[6] == 1) {
          setState(() {
            starEndText = "START CHARGE";
           
            getEnergy(widget);
            Fluttertoast.showToast(msg: "Start Charge");
          });

          Fluttertoast.showToast(msg: "Waiting-Time is not 0");
        } else if (value[6] == 2) {
          setState(() {
            starEndText = "START CHARGE";
          });
          Fluttertoast.showToast(msg: "Vehicle not connected");
        }

        break;

      case 83:
        if (value[6] == 0) {
          setState(() {
            starEndText = "START CHARGE";
            starEndcolor = Colors.blue[900];
            isEnd= true;
            prefs.setBool("isChargeing", false);
            getEnergy(widget);
          });
        }

        if (value[6] == 3) {
          Fluttertoast.showToast(msg: "failed,PEVC error.");
        }

        print('end Charge');

        break;

      case 87: /*81  END CHARGE */
        print("Collback CHANGE CHARGE");
        print(value);
     
        print(
            ' Collback=====================================================================================>Collback CHANGE CHARGE');
    }
  }

  upDateTotalkW(double  totalkW,var mYear,var mMonth) async { //TOTAL  사용량 업데이트
   print(
            ' Collback=====================================================================================>TOTAL  사용량 업데이트');
   
    


    var r = await Firestore.instance
        .collection('chargeTable')
        .document(widget.state.user.firebaseUser.uid)
        .collection('montlyData')
        .where("m_year", isEqualTo: mYear)
        .where("m_month", isEqualTo: mMonth)
        .getDocuments();

    if (r.documents.length > 0) {
      Firestore.instance
          .collection('chargeTable')
          .document(widget.state.user.firebaseUser.uid)
          .collection('montlyData')
          .document(r.documents[0].documentID)
          .updateData({
        'totalCnt': r.documents[0]['totalCnt'] + 1,
        'totalkW': r.documents[0]['totalkW'] + totalkW,
      });
    } else {
      Firestore.instance
          .collection('chargeTable')
          .document(widget.state.user.firebaseUser.uid)
          .collection('montlyData')
          .add({
        'user_id': widget.state.user.firebaseUser.uid,
        'user_nm': widget.state.user.firebaseUser.displayName,
        'deviceName': widget.device.name,
        'deviceId': widget.device.id.toString(),
        'm_year': mYear,
        'm_month': mMonth,
        'totalCnt': 1,
        'totalkW': totalkW,
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }
}

bool isThree_phase_voltage(int a, int b, int c) {
  if ((a - b).abs() <= a / 5 &&
      (a - b).abs() <= b / 5 &&
      (a - c).abs() <= a / 5 &&
      (a - c).abs() <= c / 5 &&
      (b - c).abs() <= b / 5 &&
      (b - c).abs() <= c / 5) {
    return true;
  }
  return false;
}

hexStringToBytes(String hexString) {
  if (hexString == null || hexString == "") {
    return null;
  }
  hexString = hexString.toUpperCase();

  double length = hexString.length / 2;

  //List<String> hexChars = hexString.split('');

  var d = [];

  for (var i = 0; i < length; i++) {
    var pos = i * 2;
    print(hexString.substring(1, 2));
    print(charToByte(hexString.substring(pos, pos + 1)));

    print((charToByte(hexString.substring(pos, pos + 1)) << 4) |
        charToByte(hexString.substring(pos + 1, pos + 2)));
    d.add((charToByte(hexString.substring(pos, pos + 1)) << 4) |
        charToByte(hexString.substring(pos + 1, pos + 2)));
  }
  print(d);

  return d;
}

charToByte(var c) {
  return "0123456789ABCDEF".indexOf(c);
}
