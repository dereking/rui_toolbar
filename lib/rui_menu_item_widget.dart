import 'dart:math';

import 'package:flutter/material.dart';

import 'rui_menu_item.dart';

class RuiMenuItemWidget extends StatelessWidget {
  final RuiMenuItem item;

  final double iconScale;

  final double menuIconSize;
  final double minWidth;

  static double gutSize = 5;

  const RuiMenuItemWidget({
    super.key,
    required this.item,
    required this.minWidth,
    required this.iconScale,
    required this.menuIconSize,
  });

  @override
  Widget build(BuildContext context) {
    if (item.tooltip != null) {
      return Tooltip(message: item.tooltip, child: _buildMain());
    }

    return _buildMain();
  }

  Widget _buildMain() {
    return SizedBox(
      width: max(
        minWidth,
        2 * menuIconSize +
            item.title.length * 8 +
            gutSize +
            (item.hasSubItems ? 32 : 0),
      ),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            child: Text(
              (item.checked != null && item.checked!) ? "✓" : " ",
            ),
          ),
          Icon(item.icon, size: menuIconSize),
          Container(width: gutSize),
          Text(item.title),
          if (item.hasSubItems) const Spacer(),
          if (item.hasSubItems) const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
