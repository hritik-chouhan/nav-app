import 'dart:convert';
import 'dart:io';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_navigation/kuksa/config.dart';
import 'package:flutter_navigation/kuksa/paths.dart';

import 'class-provider.dart';

class VISS {
  static const requestId = "test-id";
  static void init(WebSocket socket) {
    authorize(socket);
    subscribe(socket, VSPath.vehicleCurrentLatitude);
    subscribe(socket, VSPath.vehicleCurrentLongitude);
    subscribe(socket, VSPath.vehicleDestinationLatitude);
    subscribe(socket, VSPath.vehicleDestinationLongitude);

  }

  static void update(WebSocket socket) {
    get(socket, VSPath.vehicleCurrentLatitude);
    get(socket, VSPath.vehicleCurrentLongitude);
    get(socket, VSPath.vehicleDestinationLatitude);
    get(socket, VSPath.vehicleDestinationLongitude);



  }

  static void authorize(WebSocket socket) {
    Map<String, dynamic> map = {
      "action": "authorize",
      "tokens": VehicleSignalConfig.authToken,
      "requestId": requestId
    };
    socket.add(jsonEncode(map));
  }

  static void get(WebSocket socket, String path) {
    Map<String, dynamic> map = {
      "action": "get",
      "tokens": VehicleSignalConfig.authToken,
      "path": path,
      "requestId": requestId
    };
    socket.add(jsonEncode(map));
  }

  static void set(WebSocket socket, String path, String value) {
    Map<String, dynamic> map = {
      "action": "set",
      "tokens": VehicleSignalConfig.authToken,
      "path": path,
      "requestId": requestId,
      "value": value
    };
    socket.add(jsonEncode(map));
  }

  static void subscribe(WebSocket socket, String path) {
    Map<String, dynamic> map = {
      "action": "subscribe",
      "tokens": VehicleSignalConfig.authToken,
      "path": path,
      "requestId": requestId
    };
    socket.add(jsonEncode(map));
  }

  static String? numToGear(int? number) {
    switch (number) {
      case -1:
        return 'R';
      case 0:
        return 'N';
      case 126:
        return 'P';
      case 127:
        return 'D';
      default:
        return null;
    }
  }

  static void parseData(WidgetRef ref, String data) {
    final vehicleSignal = ref.read(vehicleSignalProvider.notifier);
    Map<String, dynamic> dataMap = jsonDecode(data);
    if (dataMap["action"] == "subscription" || dataMap["action"] == "get") {
      if (dataMap.containsKey("data")) {
        if ((dataMap["data"] as Map<String, dynamic>).containsKey("dp") &&
            (dataMap["data"] as Map<String, dynamic>).containsKey("path")) {
          String path = dataMap["data"]["path"];
          Map<String, dynamic> dp = dataMap["data"]["dp"];
          if (dp.containsKey("value")) {
            if (dp["value"] != "---") {
              switch (path) {


                case VSPath.vehicleCurrentLatitude:
                  vehicleSignal.update(
                      currentLatitude: double.parse(dp["value"]));
                  break;
                case VSPath.vehicleCurrentLongitude:
                  vehicleSignal.update(
                      currentLongitude: double.parse(dp["value"]));
                  break;
                case VSPath.vehicleDestinationLatitude:
                  vehicleSignal.update(
                      destinationLatitude: double.parse(dp["value"]));
                  break;
                case VSPath.vehicleDestinationLongitude:
                  vehicleSignal.update(
                      destinationLongitude: double.parse(dp["value"]));
                  break;

                default:
                  print("$path Not Available yet!");
              }
            } else {
              print("ERROR:Value not available yet! Set Value of $path");
            }
          } else {
            print("ERROR:'value': Key not found!");
          }
        } else if ((!dataMap["data"] as Map<String, dynamic>)
            .containsKey("path")) {
          print("ERROR:'path':key not found !");
        } else if ((dataMap["data"] as Map<String, dynamic>)
            .containsKey("dp")) {
          print("ERROR:'dp':key not found !");
        }
      } else {
        print("ERROR:'data':key not found!");
      }
    }
  }
}