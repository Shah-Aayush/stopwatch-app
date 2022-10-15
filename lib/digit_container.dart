import 'package:flutter/material.dart';
import 'dart:ui';

class DigitsContainer extends StatelessWidget {
  const DigitsContainer(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 70.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
