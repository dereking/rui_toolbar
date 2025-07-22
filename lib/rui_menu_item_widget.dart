import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rui_menu_item.dart';

class RuiMenuItemWidget extends StatefulWidget {
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
  State<RuiMenuItemWidget> createState() => _RuiMenuItemWidgetState();
}

class _RuiMenuItemWidgetState extends State<RuiMenuItemWidget> {
  @override
  Widget build(BuildContext context) {
    // final item = Provider.of<RuiMenuItem>(context);
    if (widget.item.tooltip != null) {
      return Tooltip(message: widget.item.tooltip, child: _buildMain( widget.item));
    }

    return _buildMain( widget.item);
  }

  Widget _buildMain(RuiMenuItem item) { 
    return SizedBox(
      width: max(
        widget.minWidth,
        2 * widget.menuIconSize +
            item.title.length * 8 +
            RuiMenuItemWidget.gutSize +
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
          Icon(item.icon, size: widget.menuIconSize),
          Container(width: RuiMenuItemWidget.gutSize),
          Text(item.title),
          if (item.hasSubItems) const Spacer(),
          if (item.hasSubItems) const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
