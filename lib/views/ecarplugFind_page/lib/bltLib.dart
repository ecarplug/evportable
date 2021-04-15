import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';

final int INITIAL_VALUE = 65535;
int POLYNOMIAL = 40961;
List<int> fromHex(String hexStr) {
  if (hexStr.length < 1) {
    return null;
  }
  List<int> result = new List<int>();
  for (int i = 0; i < hexStr.length / 2; i++) {
    int high = int.parse(hexStr.substring(i * 2, (i * 2) + 1), radix: 16);

    result.add((high * 16) +
        int.parse(hexStr.substring((i * 2) + 1, (i * 2) + 2), radix: 16));
  }
  return result;
}

String getCRC(var bytes) {
  int CRC = INITIAL_VALUE;
  bytes.forEach((i) {
    CRC ^= i & 255;
    for (int j = 0; j < 8; j++) {
      if ((CRC & 1) != 0) {
        CRC = (CRC >> 1) ^ POLYNOMIAL;
      } else {
        CRC >>= 1;
      }
    }
  });
  return CRC.toRadixString(16);
}

class DebugBt {
  static List<int> a;
  int de_power ;
  


}

class ByteUtils {
  static int BYTE_MAX = 255;
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


        hexStringToBytes(String hexString) {
          final myInteger = 2020;
          hexString = myInteger.toRadixString(16); 

    }
