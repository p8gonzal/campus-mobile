

import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:campus_mobile_experimental/app_styles.dart';
import 'package:campus_mobile_experimental/core/providers/user.dart';
import 'package:campus_mobile_experimental/core/providers/wayfinding.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';

class AdvancedWayfindingPermission extends StatefulWidget {
  @override
  _AdvancedWayfindingPermissionState createState() =>
      _AdvancedWayfindingPermissionState();
}

class _AdvancedWayfindingPermissionState
    extends State<AdvancedWayfindingPermission> {
  late WayfindingProvider _wayfindingProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _wayfindingProvider = Provider.of<WayfindingProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    _wayfindingProvider = Provider.of<WayfindingProvider>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(42),
        child: AppBar(
          backgroundColor: ColorPrimary,
          brightness: Brightness.dark,
          primary: true,
          centerTitle: true,
          title: Text("Advanced Wayfinding"),
        ),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          toggleSwitch(context),
          Container(
              padding: const EdgeInsets.all(16.0),
              child: Text("Advanced wayfinding benefits",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left)),
          Container(
              padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
              child: Text(
                  "\u2022 Getting directions\n\n\u2022 Locate areas of interest on campus\n\n\u2022 Context aware communication with other Bluetooth devices",
                  style: TextStyle(fontSize: 17)))
        ]);
  }

  Widget toggleSwitch(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Enable advanced wayfinding",
            style: TextStyle(fontSize: 17),
          ),
        ),
        Spacer(),
        StreamBuilder(
            stream: FlutterBlue.instance.state,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Switch(
                value: _wayfindingProvider.permissionState(
                    context, snapshot),
                onChanged: (permissionGranted) {
                  _wayfindingProvider.startBluetooth(
                      context, permissionGranted);
                  if (_wayfindingProvider.forceOff) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          if (Platform.isIOS) {
                            return CupertinoAlertDialog(
                              title: Text(
                                  "UCSD Mobile would like to use Bluetooth and location."),
                              content: Text(
                                  "This feature use Bluetooth and location to connect with other devices."),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Settings'),
                                  onPressed: () {
                                    AppSettings.openAppSettings();
                                  },
                                )
                              ],
                            );
                          }
                          return AlertDialog(
                            title: Text(
                                "UCSD Mobile would like to use Bluetooth and location."),
                            content: Text(
                                "This feature use Bluetooth and location to connect with other devices."),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Settings'),
                                onPressed: () {
                                  AppSettings.openAppSettings();
                                },
                              )
                            ],
                          );
                        });
                  }
                  setState(() {
                    if (_wayfindingProvider.forceOff) {
                      _wayfindingProvider.advancedWayfindingEnabled =
                      false;
                    } else {
                      _wayfindingProvider.advancedWayfindingEnabled =
                      !_wayfindingProvider.advancedWayfindingEnabled!;
                    }

                    if (!_wayfindingProvider.advancedWayfindingEnabled!) {
                      _wayfindingProvider.stopScans();
                    }
                    _wayfindingProvider.setAWPreference();
                  });
                },
                activeColor: Theme.of(context).buttonColor,
              )
                  : CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary);
            })
      ],
    );
  }
}
