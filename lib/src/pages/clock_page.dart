// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:octal_clock/octal_clock.dart';

import '../widgets/clock_faces/clock_face_type.dart';
import '../widgets/clock_faces/clock_face_widget.dart';
import '../widgets/clock_settings_drawer.dart';


class ClockPage extends StatefulWidget {
  ClockPage({Key key}) : super(key: key);

  @override
  _ClockPageState createState() => new _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  Timer _timer;
  OctalDateTime _time;

  ClockFaceType _type;
  double _heightFactor;
  Color _color;

  @override
  void initState() {
    super.initState();
    _time = new OctalDateTime.now();

    const duration = const Duration(
        milliseconds: OctalDuration.MILLISECONDS_PER_SECOND ~/ 4);
    _timer = new Timer.periodic(duration, _updateTime);

    _type = ClockFaceType.analog;
    _heightFactor = 0.5;
    _color = null;
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

  void _updateClockType(ClockFaceType type) {
    setState(() {
      _type = type;
    });
  }

  void _updateClockSize(double heightFactor) {
    setState(() {
      _heightFactor = heightFactor;
    });
  }

  void _updateClockColor(Color color) {
    setState(() {
      _color = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    final String date = '${_time.year}-${_time.month}-${_time.day}';

    final Color color = _color ?? themeData.textTheme.display1.color;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Octal Clock'),
      ),
      drawer: new ClockSettingsDrawer(
        activeType: _type,
        heightFactor: _heightFactor,
        activeColor: color,
        onChangeClockType: this._updateClockType,
        onChangeClockSize: this._updateClockSize,
        onChangeClockColor: this._updateClockColor,
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.all(20.0),
              child: new Text(date, style: themeData.textTheme.headline),
            ),
            new Expanded(
              flex: 2,
              child: new ClockFaceWidget(
                type: _type,
                heightFactor: _heightFactor,
                hour: _time.hour,
                minute: _time.minute,
                second: _time.second,
                millisecond: _time.millisecond,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
