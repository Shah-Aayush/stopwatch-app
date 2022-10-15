import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:stopwatch/screens/records_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/lap.dart';

bool? isNewLaunch;
SharedPreferences? prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  isNewLaunch = prefs!.getBool("isNewLaunch");
  print('isNewLaunch:$isNewLaunch');
  await prefs!.setBool("isNewLaunch", false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StopWatch',
      theme: ThemeData(
        backgroundColor: Colors.white,
        fontFamily: 'avenir-next',
      ),
      home: const MyHomePage(title: 'StopWatch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum SelectedSegment { timer, record }

class _MyHomePageState extends State<MyHomePage> {
  int milliseconds = 0, seconds = 0, minutes = 0, hours = 0;
  late Timer timer;
  bool active = false;
  bool isHourFormat = false;
  List<Lap> laps = [];
  SelectedSegment currentSegment = SelectedSegment.timer;

  _setLaps() async {
    List<Lap> initLaps = [];
    final String encodedLaps = Lap.encode(initLaps);
    await prefs!.setString('laps', encodedLaps);
    // final String? lapsString = prefs!.getString('laps');
    // laps = Lap.decode(lapsString!);
  }

  @override
  void initState() {
    super.initState();
    if (isNewLaunch == null) {
      print('isNewLaunch is null');
      _setLaps();
    } else {
      print('isNewLaunch is not null : $isNewLaunch');
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void cleanLaps() {
    setState(() {
      laps = [];
    });
  }

  void addLap() {
    String lap = isHourFormat
        ? '${(hours >= 10) ? '$hours' : '0$hours'}:${(minutes >= 10) ? '$minutes' : '0$minutes'}:${(seconds >= 10) ? '$seconds' : '0$seconds'}'
        : '${(minutes >= 10) ? '$minutes' : '0$minutes'}:${(seconds >= 10) ? '$seconds' : '0$seconds'}.${(roundOffMilliSeconds(milliseconds) >= 10) ? '${roundOffMilliSeconds(milliseconds)}' : '0${roundOffMilliSeconds(milliseconds)}'}';

    setState(
      () {
        laps.add(
          Lap(
            title: 'Lap ${laps.length}',
            hours: hours,
            minutes: minutes,
            seconds: seconds,
            milliseconds: milliseconds,
          ),
        );
      },
    );
  }

  void stop() {
    timer.cancel();
    setState(() {
      active = false;
    });
  }

  void reset() {
    timer.cancel();
    setState(() {
      milliseconds = 0;
      seconds = 0;
      minutes = 0;
      active = false;
    });
  }

  void increment() {
    setState(() {
      active = true;
    });
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      int localMilliSeconds = milliseconds + 1;
      int localSeconds = seconds;
      int localMinutes = minutes;
      int localHours = hours;
      if (localMilliSeconds > 999) {
        localMilliSeconds = 0;
        localSeconds++;
        if (localSeconds > 59) {
          localMinutes++;
          localSeconds = 0;
          if (localMinutes > 59) {
            localMinutes = 0;
            localHours++;
            setState(() {
              isHourFormat = true;
              print('isHourFormat changed.');
            });
          }
        }
      }
      setState(() {
        milliseconds = localMilliSeconds;
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        this.timer = timer;
      });
      // print('$localMinutes $localSeconds $localMilliSeconds ');
    });
  }

  int roundOffMilliSeconds(int milliseconds) {
    return (milliseconds / 10).round();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Column(
            children: <Widget>[
              const Text(
                'Timer',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: CupertinoSlidingSegmentedControl<SelectedSegment>(
                  thumbColor: Colors.black,
                  backgroundColor: Colors.white,
                  children: {
                    SelectedSegment.timer: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Text(
                        'Timer',
                        style: TextStyle(
                          color: currentSegment == SelectedSegment.timer
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SelectedSegment.record: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: Text(
                        'Records',
                        style: TextStyle(
                          color: currentSegment == SelectedSegment.record
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  },
                  onValueChanged: (value) {
                    setState(() {
                      currentSegment = value!;
                    });
                  },
                  groupValue: currentSegment,
                ),
              ),
              if (currentSegment == SelectedSegment.timer)
                Container(
                  margin: const EdgeInsets.only(top: 30.0, bottom: 20),
                  child: Text(
                    isHourFormat
                        ? '${(hours >= 10) ? '$hours' : '0$hours'}:${(minutes >= 10) ? '$minutes' : '0$minutes'}:${(seconds >= 10) ? '$seconds' : '0$seconds'}'
                        : '${(minutes >= 10) ? '$minutes' : '0$minutes'}:${(seconds >= 10) ? '$seconds' : '0$seconds'}.${(roundOffMilliSeconds(milliseconds) >= 10) ? '${roundOffMilliSeconds(milliseconds)}' : '0${roundOffMilliSeconds(milliseconds)}'}',
                    style: const TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              if (currentSegment == SelectedSegment.timer)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (active) ? addLap : reset,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(
                            180.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            active ? 'Lap' : 'Reset',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (active) ? stop : increment,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: active
                              ? const Color.fromRGBO(198, 33, 65, 1.0)
                              : const Color.fromRGBO(41, 158, 120, 1.0),
                          borderRadius: BorderRadius.circular(
                            180.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            active ? 'Stop' : 'Start',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Container(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  right: 40.0,
                  left: 40.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        const Text(
                          'Hour Format :',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        CupertinoSwitch(
                          value: isHourFormat,
                          onChanged: (bool? value) {
                            setState(() {
                              isHourFormat = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    if (currentSegment == SelectedSegment.timer)
                      GestureDetector(
                        onTap: cleanLaps,
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (currentSegment == SelectedSegment.timer)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 30.0),
                    child: Container(
                      // padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black12)),
                      child: ListView.builder(
                        itemCount: laps.length,
                        itemBuilder: (context, index) {
                          index = laps.length - index - 1;
                          return ListTile(
                            tileColor: index % 2 == 0
                                ? const Color.fromRGBO(239, 239, 239, 1)
                                : Colors.white,
                            title: Text(
                              laps[index].title,
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            trailing: Text(
                              isHourFormat
                                  ? '${(laps[index].hours >= 10) ? '${laps[index].hours}' : '0${laps[index].hours}'}:${(laps[index].minutes >= 10) ? '${laps[index].minutes}' : '0${laps[index].minutes}'}:${(laps[index].seconds >= 10) ? '${laps[index].seconds}' : '0${laps[index].seconds}'}'
                                  : '${(laps[index].minutes >= 10) ? '${laps[index].minutes}' : '0${laps[index].minutes}'}:${(laps[index].seconds >= 10) ? '${laps[index].seconds}' : '0${laps[index].seconds}'}.${(roundOffMilliSeconds(laps[index].milliseconds) >= 10) ? '${roundOffMilliSeconds(laps[index].milliseconds)}' : '0${roundOffMilliSeconds(laps[index].milliseconds)}'}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              if (currentSegment == SelectedSegment.record)
                RecordsScreen(prefs: prefs),
            ],
          ),
        ),
      ),
    );
  }
}
