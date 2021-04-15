import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:convert/convert.dart';

class PEVCController extends StatefulWidget {
  final BluetoothDevice server;

  const PEVCController({this.server});

  @override
  _PEVCController createState() => new _PEVCController();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _PEVCController extends State<PEVCController> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();

  String starEndText = '충전시작';
  Color starEndcolor = Colors.blue[900];
  String starEnd = 's';
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  static MediaQueryData mediaQuery;
  bool isDisconnecting = false;
  List<bool> _selections = [false, false, false];
  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to ' + widget.server.name + '...')
              : isConnected
                  ? Text('Live chat with ' + widget.server.name)
                  : Text('Chat log with ' + widget.server.name))),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(children: <Widget>[
                  SizedBox(
                      height: 30, width: MediaQuery.of(context).size.width),
                  CustomToggleButtons(
                    children: <Widget>[
                      mainIcon('16V', Icons.power),
                      mainIcon('10V', Icons.power),
                      mainIcon('6V', Icons.power),
                    ],
                    isSelected: _selections,
                    onPressed: (int index) {
                      setState(() {
                        _selections = [false, false, false];
                        _selections[index] = true;
                        print(_selections[index]);
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
                    height: 50,
                  ),
                  Text(
                    '중천진행용량: 2321 kw',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '충전시작시간: 2010년10월21일 10:23[25분진행]',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '충전완료시간: 2010년10월21일 11:23[40분남음]',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  RaisedButton.icon(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textColor: Colors.white,
                    disabledTextColor: Colors.grey,
                    color: starEndcolor,
                    onPressed: isConnected ? () => _sendMessage(starEnd) : null,
                    icon: Icon(Icons.check, size: 25),
                    label: Text(
                      starEndText,
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ]),
              ],
            ),
            Flexible(
              child: ListView(
                  padding: const EdgeInsets.all(12.0),
                  controller: listScrollController,
                  children: list),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      style: const TextStyle(fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnecting
                            ? 'Wait until connected...'
                            : isConnected
                                ? 'Type your message...'
                                : 'Chat got disconnected',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8.0),
                  child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: isConnected
                          ? () => _sendMessage(textEditingController.text)
                          : null),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(10),
    );
  }

  Widget mainIcon(String iconText, IconData icon) {
    return Container(
        margin: const EdgeInsets.all(0.0),
        padding: const EdgeInsets.all(10.0),
        decoration: myBoxDecoration(), //             <--- BoxDecoration here
        child: Column(
          children: [Text(iconText), Icon(icon)],
        ));
  }

  Widget mainIcon2(String iconText, IconData icon) {
    VoidCallback onTap;
    BorderRadius _baseBorderRadius = BorderRadius.circular(10);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: _baseBorderRadius),
      child: InkWell(
        borderRadius: _baseBorderRadius,
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: _baseBorderRadius,
              color: Colors.blue[500],
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.blue[900],
                  ),
                  Text(
                    iconText,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;

    //print(data.toList());

    data.forEach((byte) {
      print('byte=' + byte.toString());
      //   if (byte == 8 || byte == 127) {
      //  backspacesCounter++;
      //  }
    });
    if (data[0] == 0xA5)
      setState(() {
        messages.clear();
        messages.add(
          _Message(
            1,
            "충전준비",
          ),
        );
      });
    // print('buffer.length=' + data.length.toString());
    //  }
    // print(data.toList());
    if (data.toList().length > 3) {
      //   print(data.toList()[2].toString());
    }
  }

  void _sendMessage(String text) async {
    textEditingController.clear();

    if (text.length > 0) {
      try {
        //connection.output.add(utf8.encode(text + "\r\n"));

        Uint8List uint8list1 = utf8.encode(text);

        //connection.output.add(uint8list1);
        if (text == 's') {
          starEndText = "충전완료";
          starEndcolor = Colors.grey;
          starEnd = 'e';
          Uint8List uint8list = Uint8List.fromList(
              [0xA5, 0x02, 0x00, 0x50, 0x02, 0x20, 0x1C, 0x47, 0x21]);

          connection.output.add(uint8list);
        }

        if (text == 'e') {
          starEndText = "충전시작";
          starEndcolor = Colors.blue[900];
          starEnd = 's';
          Uint8List uint8list =
              Uint8List.fromList([0xA5, 0x03, 0x00, 0x52, 0x00, 0x65, 0x45]);

          connection.output.add(uint8list);
        }

        if (text == 'c') {
          Uint8List uint8list =
              Uint8List.fromList([0xA5, 0x01, 0x00, 0x12, 0x00, 0x65, 0x45]);

          connection.output.add(uint8list);
        }

        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

class Util {
  static List<int> convertInt2Bytes(value, Endian order, int bytesSize) {
    try {
      final kMaxBytes = 8;
      var bytes = Uint8List(kMaxBytes)
        ..buffer.asByteData().setInt64(0, value, order);
      List<int> intArray;
      if (order == Endian.big) {
        intArray = bytes.sublist(kMaxBytes - bytesSize, kMaxBytes).toList();
      } else {
        intArray = bytes.sublist(0, bytesSize).toList();
      }
      return intArray;
    } catch (e) {
      print('util convert error: $e');
    }
    return null;
  }
}
