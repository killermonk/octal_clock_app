// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

typedef ColorSelectCallback(Color color);

class ColorBoxGroup extends StatelessWidget {
  const ColorBoxGroup({
    Key key,
    @required this.width,
    @required this.height,
    @required this.colors,
    this.spacing = 0.0,
    this.groupValue,
    this.onTap,
  });

  /// The width of each color box in the group
  final double width;

  /// The height of each color box in the group
  final double height;

  /// The callback for if a given color is clicked
  final ColorSelectCallback onTap;

  /// The colors to display in this color group
  final List<Color> colors;

  /// The color that is selected for the group
  final Color groupValue;

  /// The spacing between each color
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      spacing: spacing,
      children: new List.from(colors.map((color) =>
      new ColorBox(
        key: new Key("color-$color"),
        width: width,
        height: height,
        color: color,
        selected: color == groupValue,
        onTap: () => onTap(color),
      ))),
    );
  }
}

class ColorBox extends StatelessWidget {
  const ColorBox({
    Key key,
    @required this.width,
    @required this.height,
    @required this.color,
    this.selected = false,
    this.onTap,
  })
      : assert(width != null && width > 0),
        assert(height != null && height > 0),
        assert(color != null),
        super(key: key);

  /// The width of the ColorBox
  final double width;

  /// The height of the ColorBox
  final double height;

  /// The color to fill the ColorBox with
  final Color color;

  /// Override the groupValue toggling
  final bool selected;

  /// Callback for when this ColorBox is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    BoxBorder border;
    if (selected) {
      border = new Border.all(color: Colors.black, width: 2.0);
    }

    return new GestureDetector(
      onTap: onTap,
      child: new SizedBox(
        width: width,
        height: height,
        child: new Container(
          decoration: new BoxDecoration(
            color: color,
            border: border,
          ),
        ),
      ),
    );
  }
}