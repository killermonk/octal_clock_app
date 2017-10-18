// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of clock_face_widget;

/// A clock face that displays the time like a digital watch
class _DigitalClockFace extends StatelessWidget implements ClockFaceWidget {
  final _ClockData data;

  // Size from 10.0 to 50.0
  static const MIN_SIZE = 10.0;
  static const SIZE_RANGE = 40.0;

  const _DigitalClockFace({Key key, @required this.data})
      : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MIN_SIZE + (SIZE_RANGE * data.heightFactor);
    final Color color = data.color;

    final Widget padding = new SizedBox(width: height / 10.0);

    // Normal hh:mm:ss parts
    final List<Widget> children = <Widget>[
      new DigitalNumber(
          value: data.hour, height: height, color: color, padLeft: 2),
      padding,
      new DigitalColon(height: height, color: color),
      padding,
      new DigitalNumber(
          value: data.minute, height: height, color: color, padLeft: 2),
      padding,
      new DigitalColon(height: height, color: color),
      padding,
      new DigitalNumber(
          value: data.second, height: height, color: color, padLeft: 2),
    ];

    // Milliseconds, if we want them
    if (data.millisecond != null) {
      children.addAll(<Widget>[
        padding,
        new DigitalDot(height: height, color: color),
        padding,
        new DigitalNumber(
            value: data.millisecond, height: height, color: color, padLeft: 3),
      ]);
    }

    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
