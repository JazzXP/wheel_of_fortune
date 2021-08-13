import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class RainbowStyleStrategy
    with DisableAwareStyleStrategy
    implements StyleStrategy {
  final List<int> disabledIndices;
  final List<Color> colors;

  Color _getFillColor(ThemeData theme, int index, int itemCount) {
    return colors[index % colors.length];
  }

  const RainbowStyleStrategy({
    this.disabledIndices = const <int>[],
    this.colors = const <Color>[
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.cyan,
      Colors.blue,
      Colors.purple,
    ],
  });

  /// {@macro flutter_fortune_wheel.StyleStrategy.getItemStyle}
  @override
  FortuneItemStyle getItemStyle(ThemeData theme, int index, int itemCount) {
    return getDisabledItemStyle(
      theme,
      index,
      itemCount,
      () => FortuneItemStyle(
        color: _getFillColor(theme, index, itemCount),
        borderColor: theme.primaryColor,
        borderWidth: 0.0,
        textAlign: TextAlign.start,
        textStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
