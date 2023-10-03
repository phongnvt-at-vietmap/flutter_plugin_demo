package com.example.flutter_plugin_demo;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
  private static final String BATTERY_CHANNEL = "com.example.flutter_counter_bloc/battery";
  private static final String CHARGING_CHANNEL = "com.example.flutter_counter_bloc/charging";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    new EventChannel(flutterEngine.getDartExecutor(), CHARGING_CHANNEL).setStreamHandler(
      new StreamHandler() {
        private BroadcastReceiver chargingStateChangeReceiver;
        @Override
        public void onListen(Object arguments, EventSink events) {
          chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
          registerReceiver(
              chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        }

        @Override
        public void onCancel(Object arguments) {
          unregisterReceiver(chargingStateChangeReceiver);
          chargingStateChangeReceiver = null;
        }
      }
    );

    new MethodChannel(flutterEngine.getDartExecutor(), BATTERY_CHANNEL).setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(MethodCall call, Result result) {
          if (call.method.equals("getBatteryLevel")) {
            int batteryLevel = getBatteryLevel();

            if (batteryLevel != -1) {
              result.success(batteryLevel);
            } else {
              result.success(100);
            }
          } else {
            result.notImplemented();
          }
        }
      }
    );
  }

  private BroadcastReceiver createChargingStateChangeReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

        if (status == BatteryManager.BATTERY_STATUS_UNKNOWN) {
          events.error("UNAVAILABLE", "Charging status unavailable", null);
        } else {
          boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                               status == BatteryManager.BATTERY_STATUS_FULL;
          events.success(isCharging ? "charging" : "discharging");
        }
      }
    };
  }

  private int getBatteryLevel() {
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      return (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }
  }
}
