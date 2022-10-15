import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/models/lap.dart';

class RecordsScreen extends StatefulWidget {
  final SharedPreferences? prefs;
  // final Map data;
  const RecordsScreen({
    super.key,
    required this.prefs,
    // required this.data,
  });

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late final _prefs;

  List<Lap> laps = [];
  // late SharedPreferences _prefs;

  @override
  void initState() {
    _prefs = widget.prefs;
    _getLaps();
    super.initState();
  }

  _getLaps() async {
    laps = Lap.decode(_prefs.getString('laps')!);
    laps.add(Lap(
        title: '${laps.length + 1}',
        hours: 1,
        minutes: 1,
        seconds: 1,
        milliseconds: 1));
    await _prefs.setString('laps', Lap.encode(laps));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: laps.isEmpty
            ? const Text('empty laps!')
            : ListView.builder(
                itemCount: laps.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.list),
                    trailing: Text(
                      '${laps[index].hours}:${laps[index].minutes}:${laps[index].seconds}',
                      style: const TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    title: Text(laps[index].title),
                  );
                }),
      ),
    );
  }
}
