import 'package:freezed_annotation/freezed_annotation.dart';

part 'battery_state.freezed.dart';

@freezed
class BatteryState with _$BatteryState {
  const factory BatteryState.initial() = _Initial;
  const factory BatteryState.data(int percentage) = _Data;
}
