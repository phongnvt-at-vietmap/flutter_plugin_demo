import 'package:freezed_annotation/freezed_annotation.dart';

part 'battery_event.freezed.dart';

@freezed
class BatteryEvent with _$BatteryEvent {
  const factory BatteryEvent.initial() = _Initial;
  const factory BatteryEvent.get() = _Get;
}
