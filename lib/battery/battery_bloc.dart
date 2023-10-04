import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'battery_event.dart';
import 'battery_state.dart';

class BatteryBloc extends Bloc<BatteryEvent, BatteryState> {
  static const platform =
      MethodChannel('com.example.flutter_counter_bloc/battery');
  BatteryBloc() : super(const BatteryState.initial()) {
    on<BatteryEvent>((event, emit) async {
      BatteryState newState = await event.maybeWhen(
        orElse: () => BatteryState.initial(),
        get: () async {
          int battery = 0;
          try {
            battery = await platform.invokeMethod('getBatteryLevel') as int;
          } catch (e) {
            battery = 0;
            log(e.toString());
          }
          return BatteryState.data(battery);
        },
      );
      emit(newState);
    });
  }
}
