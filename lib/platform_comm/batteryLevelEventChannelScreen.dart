import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryLevelEventChannelScreen extends StatefulWidget {
  @override
  _BatteryLevelStreamScreenState createState() => _BatteryLevelStreamScreenState();
}

class _BatteryLevelStreamScreenState extends State<BatteryLevelEventChannelScreen> {
  static const EventChannel _eventChannel = EventChannel('batteryStream');
  String _batteryLevel = 'Waiting for battery level...';

  @override
  void initState() {
    super.initState();
    _eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError); // Listen to event stream
  }

  void _onEvent(dynamic event) {
    setState(() {
      _batteryLevel = "Battery level: $event%";
    });
  }

  void _onError(dynamic error) {
    setState(() {
      _batteryLevel = "Battery level not available: $error";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battery Level Stream')),
      body: Center(child: Text(_batteryLevel)),
    );
  }
}
