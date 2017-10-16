// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:octal_clock/octal_clock.dart';

class ClockPage extends StatefulWidget {
  ClockPage({Key key}) : super(key: key);

  @override
  _ClockPageState createState() => new _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  Timer _timer;
  OctalDateTime _time;

  @override
  void initState() {
    super.initState();
    _time = new OctalDateTime.now();

    const duration = const Duration(
        milliseconds: OctalDuration.MILLISECONDS_PER_SECOND ~/ 4);
    _timer = new Timer.periodic(duration, _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer _) {
    setState(() {
      _time = new OctalDateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    String twoDigits(int d) {
      if (d < 10) return '0$d';
      return d.toString();
    }

    String threeDigits(int d) {
      if (d < 10) return '00$d';
      if (d < 100) return '0$d';
      return d.toString();
    }

    String formatTime(date) {
      return '${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(
          date.second)}.${threeDigits(date.millisecond)}';
    }

    final String date = '${_time.year}-${_time.month}-${_time.day}';
    final String time = formatTime(_time);

    return new Scaffold(
      appBar: new AppBar(
        leading: new Icon(Icons.watch_later),
        title: new Text('Octal Clock'),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(date, style: themeData.textTheme.headline),
            new SizedBox(height: 10.0),
            new Text(time, style: themeData.textTheme.display1),
          ],
        ),
      ),
    );
  }
}
