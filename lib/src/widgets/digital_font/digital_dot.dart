// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of digital_font;

class DigitalDot extends StatelessWidget {
  final double height;
  final Color color;

  DigitalDot({Key key, @required this.height, @required this.color})
      : assert(height != null),
        assert(color != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      size: new Size(height / 2.0, height),
      painter: new _DigitalDotPainter(height, color),
    );
  }
}

class _DigitalDotPainter extends CustomPainter {
  final double height;
  final Color color;

  _DigitalDotPainter(this.height, this.color);

  @override
  bool shouldRepaint(_DigitalDotPainter oldDelegate) {
    return height != oldDelegate.height;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double width = height / 2;
    final double thickness = width / 5;

    final Paint paint = new Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRect(new Rect.fromLTWH(
      width / 2 - thickness / 2,
      height - thickness,
      thickness,
      thickness,
    ), paint);
  }
}
