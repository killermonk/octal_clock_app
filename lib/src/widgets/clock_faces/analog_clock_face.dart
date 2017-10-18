// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of clock_face_widget;

/// An analog face for the octal clock
class _AnalogClockFace extends StatelessWidget implements ClockFaceWidget {
  final _ClockData data;

  // Size from 125.0 to 300.0
  static const MIN_SIZE = 125.0;
  static const SIZE_RANGE = 175.0;

  _AnalogClockFace({Key key, this.data})
      : assert(data != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double length = MIN_SIZE + (SIZE_RANGE * data.heightFactor);

    return new CustomPaint(
      size: new Size(length, length),
      painter: new _ClockDecorationPainter(data.color),
      foregroundPainter: new _ClockHandsPainter(
          data.hour, data.minute, data.second, data.color),
    );
  }
}

/// Get the outside point around the rotation
/// [timePart] is how many seconds, minutes, or hours have passed
/// [timeTotal] is how many seconds, minutes, or hours are in one rotation
/// [length] is how far from center we want the point to end up (eg: hand length)
Offset _getPosition(double timePart, double timeTotal, double length) {
  // What percentage of the whole have we covered
  final percentage = timePart / timeTotal;
  // -2PI*percentage is how many radians we have moved clockwise
  // then we rotate backwards 90 degrees for correct position
  final radians = 2 * PI * percentage - PI / 2;

  return new Offset(length * cos(radians), length * sin(radians));
}

/// Painter to draw the very static parts of the clock face
/// We don't need to repaint this unless we change the color, so optimize our
/// rendering by pulling it into its own painter
class _ClockDecorationPainter extends CustomPainter {
  final Color color;

  _ClockDecorationPainter(this.color);

  @override
  bool shouldRepaint(_ClockDecorationPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()
      ..color = color;

    final Offset center = new Offset(size.width / 2, size.height / 2);
    final double maxLen = min(center.dx, center.dy);

    // Clock Numbers
    final TextStyle ts = new TextStyle(
        color: color, fontWeight: FontWeight.bold);
    final TextPainter tp = new TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    for (int i = 1; i <= OctalDuration.HOURS_PER_SCISMA; i++) {
      final String hour = (i == 8) ? '10' : '$i';
      final TextSpan text = new TextSpan(text: hour, style: ts);

      final Offset paintOffset = _getPosition(
          i.toDouble(), OctalDuration.HOURS_PER_SCISMA.toDouble(),
          maxLen * .85);

      tp.text = text;
      tp.layout();

      // The text is painted with the offset being the top right corner of the render box
      // We need to adjust the box to properly center our text
      final Offset textOffset = new Offset(tp.width, tp.height) / 2.0;
      tp.paint(canvas, paintOffset + center - textOffset);
    }

    // Clock border
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, maxLen, paint);

    // The rest of the decorations
    paint
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // Center dot
    canvas.drawCircle(center, 3.0, paint);

    // Minute ticks

    // Special handling for digits under the hour marks
    const underHour = OctalDuration.MINUTES_PER_HOUR /
        OctalDuration.HOURS_PER_SCISMA;
    for (int i = 0; i < OctalDuration.MINUTES_PER_HOUR; i++) {
      double insideFactor = .95;
      if (i.remainder(underHour) == 0)
        insideFactor = .93;

      paint.colorFilter = (i.remainder(4) == 0)
          ? new ColorFilter.mode(color, BlendMode.darken)
          : null;

      final Offset outsideOffset = _getPosition(
          i.toDouble(), OctalDuration.MINUTES_PER_HOUR.toDouble(),
          maxLen - 1.5);
      final Offset insideOffset = _getPosition(
          i.toDouble(), OctalDuration.MINUTES_PER_HOUR.toDouble(),
          maxLen * insideFactor);

      canvas.drawLine(center + insideOffset, center + outsideOffset, paint);
    }
  }
}

/// Painter to draw the hands of the clock
/// This redraws most often
class _ClockHandsPainter extends CustomPainter {
  final int hour;
  final int minute;
  final int second;
  final Color color;

  _ClockHandsPainter(this.hour, this.minute, this.second, this.color);

  @override
  bool shouldRepaint(_ClockHandsPainter oldDelegate) {
    return hour != oldDelegate.hour
        || minute != oldDelegate.minute
        || second != oldDelegate.second
        || color != oldDelegate.color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()
      ..color = color;

    final Offset center = new Offset(size.width / 2, size.height / 2);
    final double maxLen = min(center.dx, center.dy);

    paint
      ..colorFilter = null
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;

    // Second hand
    final Offset secondsOffset = _getPosition(
        oct2dec(second).toDouble(), OctalDuration.SECONDS_PER_MINUTE.toDouble(),
        maxLen * .8);
    canvas.drawLine(center, center + secondsOffset, paint);

    // Minute hand
    paint.strokeWidth = 4.0;
    final int minutes = oct2dec(minute);
    final Offset minuteOffset = _getPosition(
        minutes.toDouble(), OctalDuration.MINUTES_PER_HOUR.toDouble(),
        maxLen * .75);
    canvas.drawLine(center, center + minuteOffset, paint);

    // Hour hand
    paint.strokeWidth = 6.0;
    final int hourMinutes = oct2dec(hour) * OctalDuration.MINUTES_PER_HOUR +
        minutes;
    final int scismaMinutes = OctalDuration.HOURS_PER_SCISMA *
        OctalDuration.MINUTES_PER_HOUR;
    final Offset hourOffset = _getPosition(
        hourMinutes.toDouble(), scismaMinutes.toDouble(),
        maxLen * .5);
    canvas.drawLine(center, center + hourOffset, paint);
  }
}
