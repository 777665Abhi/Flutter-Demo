package com.example.my_pro

import android.os.Bundle
import android.os.BatteryManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

//
import android.content.BroadcastReceiver
import io.flutter.plugin.common.EventChannel
import android.content.Context
import android.content.Intent
import android.content.IntentFilter

class MainActivity: FlutterActivity()
{
private val CHANNEL = "battery" // Same channel as Dart code
private val BATTERY_CHANNEL = "batteryStream"

override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    /*==============Method Channel*/
//    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//        if (call.method == "getBatteryLevel") {
//            val batteryLevel = getBatteryLevel()
//
//            if (batteryLevel != -1) {
//                result.success(batteryLevel) // Send the result to Flutter
//            } else {
//                result.error("UNAVAILABLE", "Battery level not available.", null)
//            }
//        } else {
//            result.notImplemented()
//        }
//    }
//}

//private fun getBatteryLevel(): Int {
//    val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
//    return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
//}

    /*=================Event Channel*/


    EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL).setStreamHandler(
    object : EventChannel.StreamHandler {
        private var batteryLevelReceiver: BroadcastReceiver? = null

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            batteryLevelReceiver = createBatteryLevelReceiver(events)
            registerReceiver(batteryLevelReceiver, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        }

        override fun onCancel(arguments: Any?) {
            unregisterReceiver(batteryLevelReceiver)
            batteryLevelReceiver = null
        }
    }
    )}

    private fun createBatteryLevelReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
                events?.success(level) // Send battery level to Flutter
            }
        }
    }


}