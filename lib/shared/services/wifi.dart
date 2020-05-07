import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

const String WIFI_TOCK = "IZAIAS 2702";

class WifiService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  String _connectionStatus = 'Unknown';
  String _wifiName, _wifiBSSID, _wifiIP;

  get wifiName => _wifiName;

  WifiService() {
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  bool isConnectedLocal() {
    return _wifiName == WIFI_TOCK ? true : false;
  }

  disconnect() {
    _connectivitySubscription.cancel();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print('_updateConnectionStatus changed! _wifiName: $_wifiName');
    switch (result) {
      case ConnectivityResult.wifi:
        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              _wifiName = await _connectivity.getWifiName();
            } else {
              _wifiName = await _connectivity.getWifiName();
            }
          } else {
            _wifiName = await _connectivity.getWifiName();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          _wifiName = "Failed to get Wifi Name";
        }

        try {
          if (Platform.isIOS) {
            LocationAuthorizationStatus status =
                await _connectivity.getLocationServiceAuthorization();
            if (status == LocationAuthorizationStatus.notDetermined) {
              status =
                  await _connectivity.requestLocationServiceAuthorization();
            }
            if (status == LocationAuthorizationStatus.authorizedAlways ||
                status == LocationAuthorizationStatus.authorizedWhenInUse) {
              _wifiBSSID = await _connectivity.getWifiBSSID();
            } else {
              _wifiBSSID = await _connectivity.getWifiBSSID();
            }
          } else {
            _wifiBSSID = await _connectivity.getWifiBSSID();
          }
        } on PlatformException catch (e) {
          print(e.toString());
          _wifiBSSID = "Failed to get Wifi BSSID";
        }

        try {
          _wifiIP = await _connectivity.getWifiIP();
        } on PlatformException catch (e) {
          print(e.toString());
          _wifiIP = "Failed to get Wifi IP";
        }
        _connectionStatus = '$result\n'
            'Wifi Name: $_wifiName\n'
            'Wifi BSSID: $_wifiBSSID\n'
            'Wifi IP: $_wifiIP\n';

        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        break;
      default:
        _connectionStatus = 'Failed to get connectivity.';
        break;
    }
  }
}
