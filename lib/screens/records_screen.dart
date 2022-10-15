import 'package:flutter/material.dart';
import 'dart:ui';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  leading: const Icon(Icons.list),
                  trailing: const Text(
                    "GFG",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                  title: Text("List item $index"));
            }),
      ),
    );
  }
}
