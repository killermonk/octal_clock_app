// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library clock_face_widget;

import 'dart:math';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:octal_clock/octal_clock.dart';

import '../digital_font/digital_font.dart';
import './clock_face_type.dart';

part './clock_data.dart';

part './text_clock_face.dart';

part './digital_clock_face.dart';

part './analog_clock_face.dart';

/// A widget factory to create a given Clock Face based on its type
abstract class ClockFaceWidget implements StatelessWidget {
  factory ClockFaceWidget({
    @required ClockFaceType type,
    @required int hour,
    @required int minute,
    @required int second,
    Key key,
    int millisecond,
    double heightFactor = 0.5,
    Color color = Colors.black,
  }) {
    assert(hour != null);
    assert(minute != null);
    assert(second != null);
    assert(color != null);
    assert(type != null);
    assert(heightFactor >= 0.0);
    assert(heightFactor <= 1.0);

    final _ClockData clockData = new _ClockData(
        hour: hour,
        minute: minute,
        second: second,
        millisecond: millisecond,
        color: color,
        heightFactor: heightFactor);

    switch (type) {
      case ClockFaceType.analog:
        return new _AnalogClockFace(data: clockData);

      case ClockFaceType.digital:
        return new _DigitalClockFace(data: clockData);

      case ClockFaceType.text:
      default:
        return new _TextClockFace(data: clockData);
    }
  }
}
