import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:stopwatch/models/lap.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RecordsScreen extends StatefulWidget {
  final SharedPreferences? prefs;
  final bool? isHourFormat;
  final Function roundOffMilliSeconds;
  // final Map data;
  const RecordsScreen({
    super.key,
    required this.prefs,
    required this.isHourFormat,
    required this.roundOffMilliSeconds,
    // required this.data,
  });

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  late final _prefs;
  TextEditingController _textFieldController = TextEditingController();
  bool highlightTextField = false;
  String newTitle = '';
  List<Lap> storedLaps = [];
  // late SharedPreferences _prefs;

  void _setLatestValueTitle() {
    newTitle = _textFieldController.text;
  }

  String getTitle() {
    return newTitle;
  }

  @override
  void initState() {
    _prefs = widget.prefs;
    _getLaps();
    _textFieldController.addListener(_setLatestValueTitle);
    super.initState();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  _deleteLap(index) async {
    setState(() {
      storedLaps.removeAt(index);
    });
    await _prefs.setString('laps', Lap.encode(storedLaps));
  }

  _getLaps() async {
    storedLaps = Lap.decode(_prefs.getString('laps')!);
    await _prefs.setString('laps', Lap.encode(storedLaps));
  }

  Future<void> showAlertDialogMessage(
      BuildContext context, int index, bool isEdit) async {
    final String titleText = isEdit ? 'Edit Record' : 'Delete Record';
    Widget contents = Column(
      children: [
        Text(isEdit
            ? 'Change title for `${storedLaps[index].title}`'
            : 'Are you sure you want to delete `${storedLaps[index].title}` record?'),
        if (isEdit)
          Container(
            margin: EdgeInsets.only(top: 10),
            child: CupertinoTextField(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: highlightTextField
                    ? Border.all(color: Colors.red)
                    : Border.all(color: Colors.blue),
              ),
              controller: _textFieldController,
            ),
          ),
      ],
    );
    if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(titleText),
          content: contents,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isEdit) {
                  if (_textFieldController.text.isEmpty) {
                    setState(() {
                      highlightTextField = true;
                    });
                  } else {
                    _editLap(index, getTitle());
                    Navigator.of(ctx).pop();
                  }
                } else {
                  _deleteLap(index);
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(isEdit ? 'Save' : 'Delete'),
            ),
          ],
        ),
      );
    } else {
      await showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(titleText),
          content: contents,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isEdit) {
                  if (_textFieldController.text.isEmpty) {
                    setState(() {
                      highlightTextField = true;
                    });
                  } else {
                    _editLap(index, getTitle());
                    Navigator.of(ctx).pop();
                  }
                } else {
                  _deleteLap(index);
                  Navigator.of(ctx).pop();
                }
              },
              child: Text(isEdit ? 'Save' : 'Delete'),
            ),
          ],
        ),
      );
    }
  }

  _editLap(int index, String title) async {
    setState(() {
      storedLaps[index].title = getTitle();
    });
    await _prefs.setString('laps', Lap.encode(storedLaps));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: storedLaps.isEmpty
            ? const Text('empty laps!')
            : Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black12)),
                child: ListView.builder(
                    itemCount: storedLaps.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                _textFieldController.text =
                                    storedLaps[index].title;
                                showAlertDialogMessage(context, index, true);
                                // _editLap(index, newTitle);
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                showAlertDialogMessage(context, index, false);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                            ),
                          ],
                        ),
                        child: ListTile(
                          tileColor: index % 2 == 0
                              ? const Color.fromRGBO(239, 239, 239, 1)
                              : Colors.white,
                          leading: const Icon(CupertinoIcons.stopwatch),
                          trailing: Text(
                            widget.isHourFormat!
                                ? '${(storedLaps[index].hours >= 10) ? '${storedLaps[index].hours}' : '0${storedLaps[index].hours}'}:${(storedLaps[index].minutes >= 10) ? '${storedLaps[index].minutes}' : '0${storedLaps[index].minutes}'}:${(storedLaps[index].seconds >= 10) ? '${storedLaps[index].seconds}' : '0${storedLaps[index].seconds}'}'
                                : '${(storedLaps[index].minutes >= 10) ? '${storedLaps[index].minutes}' : '0${storedLaps[index].minutes}'}:${(storedLaps[index].seconds >= 10) ? '${storedLaps[index].seconds}' : '0${storedLaps[index].seconds}'}.${(widget.roundOffMilliSeconds(storedLaps[index].milliseconds) >= 10) ? '${widget.roundOffMilliSeconds(storedLaps[index].milliseconds)}' : '0${widget.roundOffMilliSeconds(storedLaps[index].milliseconds)}'}',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 15),
                          ),
                          title: Text(storedLaps[index].title),
                        ),
                      );
                    }),
              ),
      ),
    );
  }
}
