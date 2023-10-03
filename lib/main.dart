import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_counter_bloc/battery/battery_bloc.dart';
import 'package:flutter_counter_bloc/battery/battery_event.dart';
import 'package:flutter_counter_bloc/battery/battery_state.dart';

import 'counter/app_bloc.dart';
import 'counter/app_events.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CounterBlocs()),
          BlocProvider(create: (context) => BatteryBloc()),
        ],
        child: const MaterialApp(
          home: HomePage(),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CounterBlocs, CounterStates>(
            builder: (_, state) {
              return Text(
                state.counter.toString(),
                style: const TextStyle(fontSize: 30),
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () =>
                      BlocProvider.of<CounterBlocs>(context).add(Increment()),
                  child: const Icon(Icons.add)),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () =>
                      BlocProvider.of<CounterBlocs>(context).add(Decrement()),
                  child: const Icon(Icons.remove))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SecondPage()));
            },
            child: Container(
              width: 138,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey,
              ),
              child: const Center(
                  child: Text(
                'click',
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<BatteryBloc, BatteryState>(builder: (_, state) {
            int battery = state.maybeWhen(
              orElse: () => 0,
              data: (percentage) => percentage,
            );
            return Text('Battery level: $battery');
          }),
          ElevatedButton(
              onPressed: () {
                context.read<BatteryBloc>().add(const BatteryEvent.get());
              },
              child: const Text('Get battery'))
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CounterBlocs counterBloc = BlocProvider.of<CounterBlocs>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Blocs'),
          leading: BackButton(
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder(
            bloc: counterBloc,
            builder: (context, state) {
              return Center(
                child: Text(
                  counterBloc.state.counter.toString(),
                  style: const TextStyle(fontSize: 30),
                ),
              );
            }));
  }
}
