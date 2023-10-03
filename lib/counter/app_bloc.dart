import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_events.dart';

class CounterStates {
  int counter;
  CounterStates({required this.counter});
}

class InitialState extends CounterStates {
  InitialState() : super(counter: 0);
}

class CounterBlocs extends Bloc<CounterEvents, CounterStates> {
  // Timer? timer;

  CounterBlocs() : super(InitialState()) {
    on<Increment>((event, emit) async {
      // final firstCompleter = Completer();

      // timer?.cancel();

      // timer = Timer(const Duration(seconds: 2), () async {

      // });
      await Future.delayed(const Duration(seconds: 1), () {
        emit(CounterStates(counter: state.counter + 1));
        // firstCompleter.complete();
      });

      // await firstCompleter.future;
    });

    on<Decrement>((event, emit) {
      // timer?.cancel();
      emit(CounterStates(counter: state.counter - 1));
    });
  }
}
