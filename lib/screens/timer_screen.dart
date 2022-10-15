import 'dart:ui';

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  final int hours, minutes, seconds, milliseconds;
  final bool isHourFormat;

  const TimerScreen(
      {super.key,
      required this.hours,
      required this.minutes,
      required this.seconds,
      required this.milliseconds,
      required this.isHourFormat});
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  
  int roundOffMilliSeconds(int milliseconds) {
    return (milliseconds / 10).round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50.0),
      child: Text(
        widget.isHourFormat
            ? '${(widget.hours >= 10) ? '${widget.hours}' : '0${widget.hours}'}:${(widget.minutes >= 10) ? '${widget.minutes}' : '0${widget.minutes}'}:${(widget.seconds >= 10) ? '${widget.seconds}' : '0${widget.seconds}'}'
            : '${(widget.minutes >= 10) ? '${widget.minutes}' : '0${widget.minutes}'}:${(widget.seconds >= 10) ? '${widget.seconds}' : '0${widget.seconds}'}.${(roundOffMilliSeconds(widget.milliseconds) >= 10) ? '${roundOffMilliSeconds(widget.milliseconds)}' : '0${roundOffMilliSeconds(widget.milliseconds)}'}',
        style: const TextStyle(
          fontSize: 70.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
