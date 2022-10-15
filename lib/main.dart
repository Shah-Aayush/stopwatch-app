import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:stopwatch/digit_container.dart';

void main() {
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
        primarySwatch: Colors.blue,
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

class _MyHomePageState extends State<MyHomePage> {
  int milliseconds = 0, seconds = 0, minutes = 0;
  late Timer timer;
  bool active = false;
  List laps = [];

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
    String lap =
        '${(minutes >= 10) ? '$minutes' : '0$minutes'}:${(seconds >= 10) ? '$seconds' : '0$seconds'}.${(roundOffMilliSeconds(milliseconds) >= 10) ? '${roundOffMilliSeconds(milliseconds)}' : '0${roundOffMilliSeconds(milliseconds)}'}';
    setState(() {
      laps.add(lap);
    });
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
      if (localMilliSeconds > 999) {
        localMilliSeconds = 0;
        localSeconds++;
        if (localSeconds > 59) {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        milliseconds = localMilliSeconds;
        seconds = localSeconds;
        minutes = localMinutes;
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
                margin: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text(
                  '${(minutes >= 10) ? '$minutes' : '0$minutes'}:${(seconds >= 10) ? '$seconds' : '0$seconds'}.${(roundOffMilliSeconds(milliseconds) >= 10) ? '${roundOffMilliSeconds(milliseconds)}' : '0${roundOffMilliSeconds(milliseconds)}'}',
                  style: const TextStyle(
                    fontSize: 70.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DigitsContainer(
                      (minutes >= 10) ? '$minutes' : '0$minutes',
                    ),
                    const Text(
                      ':',
                      style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        // fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    DigitsContainer(
                      (seconds >= 10) ? '$seconds' : '0$seconds',
                    ),
                    const Text(
                      '.',
                      style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        // fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    DigitsContainer(
                      (roundOffMilliSeconds(milliseconds) >= 10)
                          ? '${roundOffMilliSeconds(milliseconds)}'
                          : '0${roundOffMilliSeconds(milliseconds)}',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: reset,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white60,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          180.0,
                        ),
                      ),
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            180.0,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (active) ? stop : increment,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(174, 83, 169, 0.6),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          180.0,
                        ),
                      ),
                      child: Container(
                        height: 90.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(174, 83, 169, 1.0),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            180.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            (active) ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 60.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: addLap,
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white60,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(
                          180.0,
                        ),
                      ),
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(
                            180.0,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.flag,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 40.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: cleanLaps,
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 30.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListView.builder(
                      itemCount: laps.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          child: Text(
                            '$index - ${laps[index]}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
