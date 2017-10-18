// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

import './color_box.dart';
import './clock_faces/clock_face_type.dart';

typedef ClockTypeCallback(ClockFaceType type);
typedef ClockSizeCallback(double height);
typedef ClockColorCallback(Color color);

class ClockSettingsDrawer extends StatefulWidget {
  ClockSettingsDrawer({
    Key key,
    @required this.activeType,
    @required this.heightFactor,
    @required this.activeColor,
    @required this.onChangeClockType,
    @required this.onChangeClockSize,
    @required this.onChangeClockColor,
  })
      : assert(activeType != null),
        assert(heightFactor != null),
        assert(activeColor != null),
        assert(onChangeClockType != null),
        assert(onChangeClockSize != null),
        assert(onChangeClockColor != null),
        super(key: key);

  final ClockTypeCallback onChangeClockType;
  final ClockSizeCallback onChangeClockSize;
  final ClockColorCallback onChangeClockColor;

  final ClockFaceType activeType;
  final double heightFactor;
  final Color activeColor;


  @override
  State createState() => new _ClockSettingsDrawerState();
}

class _ClockSettingsDrawerState extends State<ClockSettingsDrawer> {
  /// The opacity of the drawer
  double _opacity;

  Timer _opacityDebounceTimer;

  @override
  void initState() {
    _opacity = 1.0;
  }

  _setOpacity(double opacity, {int debounce}) {
    void doWork() {
      setState(() {
        _opacity = opacity;
      });
    }

    if (debounce != null) {
      _opacityDebounceTimer?.cancel();
      _opacityDebounceTimer = new Timer(
        new Duration(milliseconds: debounce), () {
          doWork();
      });
    } else {
      doWork();
    }
  }

  _changeClockType(ClockFaceType type) {
    widget.onChangeClockType(type);
    _setOpacity(0.25);
    _setOpacity(1.0, debounce: 1000);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData themeData = Theme.of(context);

    return new Opacity(
      opacity: _opacity,
      child: new Drawer(
        child: new ListView(
          primary: false,
          children: <Widget>[
            new Container( // Fake a drawer header
              color: themeData.primaryColor,
              padding: new EdgeInsets.only(
                  top: mediaQuery.padding.top + 16.0, bottom: 16.0),
              child: new ListTile(
                leading: new Icon(Icons.watch_later,
                    color: themeData.primaryTextTheme.title.color),
                title: new Text(
                    'Settings', style: themeData.primaryTextTheme.title),
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.alarm),
              title: new Text('Clock Type', textScaleFactor: 1.5),
              dense: true,
            ),
            new RadioListTile(
              value: ClockFaceType.analog,
              groupValue: widget.activeType,
              onChanged: _changeClockType,
              title: new Text('Analog Clock'),
              dense: true,
            ),
            new RadioListTile(
              value: ClockFaceType.digital,
              groupValue: widget.activeType,
              onChanged: _changeClockType,
              title: new Text('Digital Clock'),
              dense: true,
            ),
            new RadioListTile(
              value: ClockFaceType.text,
              groupValue: widget.activeType,
              onChanged: _changeClockType,
              title: new Text('Text Clock'),
              dense: true,
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.format_size),
              title: new Text('Clock Size', textScaleFactor: 1.5),
              dense: true,
            ),
            new Slider(
                value: widget.heightFactor,
                onChanged: (value) {
                  widget.onChangeClockSize(value);
                  _setOpacity(0.25);
                  _setOpacity(1.0, debounce: 1000);
                }
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.color_lens),
              title: new Text('Clock Color', textScaleFactor: 1.5),
              dense: true,
            ),
            new ListTile(
              title: new ColorBoxGroup(
                width: 25.0,
                height: 25.0,
                spacing: 10.0,
                colors: [
                  themeData.textTheme.display1.color,
                  Colors.red,
                  Colors.orange,
                  Colors.green,
                  Colors.purple,
                  Colors.blue,
                  Colors.yellow,
                ],
                groupValue: widget.activeColor,
                onTap: (color) {
                  widget.onChangeClockColor(color);
                  _setOpacity(0.25);
                  _setOpacity(1.0, debounce: 1000);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
