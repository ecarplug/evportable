import 'package:ecarplugapp/views/ecarplugFind_page/lib/deviceScreen.dart';
import 'package:ecarplugapp/widgets/ble.dart';
import 'package:flutter/material.dart';

import 'package:flutter_blue/flutter_blue.dart';

/// Wrapper for stateful functionality to provide onInit calls in stateles widget
class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;
  const StatefulWrapper({@required this.onInit, @required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}
class _StatefulWrapperState extends State<StatefulWrapper> {
@override
  void initState() {
    if(widget.onInit != null) {
      widget.onInit();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }

class FindDevicesScreen extends StatelessWidget {
  FindDevicesScreen(this.state);
  final state;
  
 
  @override
  Widget build(BuildContext context) {
  return StatefulWrapper(
      onInit: () {
        _getThingsOnStartup().then((value) {
          FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
        });
      },
      child: 
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Search Device'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var flutterBlue = FlutterBlue.instance;
          await flutterBlue.stopScan();
          for (var device in await flutterBlue.connectedDevices) {
            await device.disconnect();
          }
          flutterBlue = null;

          FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              StreamBuilder<List<BluetoothDevice>>(
                stream: Stream.periodic(Duration(seconds: 2))
                    .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map((d) =>   ListTile(
                            title: Text(d.name),
                            subtitle: Text(d.id.toString()),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: d.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (c, snapshot) {
                                if (snapshot.data ==
                                    BluetoothDeviceState.connected) {
                                  return RaisedButton(
                                    child: Text('OPEN'),
                                    onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => DeviceScreen(
                                                device: d, state: state))),
                                  );
                                }
                                return Text(snapshot.data.toString());
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBlue.instance.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data
                      .map(
                        (r) =>   (r.device.name.length>3)?(r.device.name.substring(0,3)=='PUP')?ScanResultTile(
                          result: r,
                          onTap: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            r.device.connect();
                            return DeviceScreen(
                              device: r.device,
                              state: state,
                            );
                          })),
                        ): SizedBox(height: 0):SizedBox(height: 0),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.stop),
              onPressed: () => FlutterBlue.instance.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              heroTag: null,
              child: Icon(Icons.search),
              onPressed: () async {
                /*
                var flutterBlue = FlutterBlue.instance;
                await flutterBlue.stopScan();
                for (var device in await flutterBlue.connectedDevices) {
                  await device.disconnect();
                }
                flutterBlue = null;
*/
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 2));
              },
            );
          }
        },
      ),
    ));
  }
}
