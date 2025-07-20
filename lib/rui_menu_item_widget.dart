import 'package:flutter/material.dart';

import 'rui_menu_item.dart';

class RuiMenuItemWidget extends StatelessWidget {
  final RuiMenuItem item;

  final double iconScale;

  final double menuIconSize;

  static double gutSize = 5;

  const RuiMenuItemWidget({
    super.key,
    required this.item,
    required this.iconScale,
    required this.menuIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        children: [
          item.checked != null
              ? Checkbox(value: item.checked, onChanged: (checked) {})
              : Container(width: menuIconSize),
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
