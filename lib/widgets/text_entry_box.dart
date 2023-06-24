import 'package:flutter/material.dart';

/// Blank Text Entry Box
Container textEntryBox() {
  return Container(
    width: 280,
    height: 48,
    decoration: const BoxDecoration(
        image: DecorationImage(
      image: AssetImage('assets/img/TextBar.png'),
      fit: BoxFit.cover,
    )),
  );
}
