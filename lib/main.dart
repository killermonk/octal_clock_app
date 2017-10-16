// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import './src/pages/clock_page.dart';

void main() {
  runApp(new OctalClockApp());
}

class OctalClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Octal Clock',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Fixed',
      ),
      home: new ClockPage(),
    );
  }
}
