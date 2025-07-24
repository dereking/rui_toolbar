import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rui_toolbar/rui_menu_item.dart';
import 'dart:async';

import 'package:rui_toolbar/rui_menu_item_widget.dart';
import 'package:rui_toolbar/rui_tool_button.dart';

class RecursiveMenuController {
  final List<OverlayEntry> _entries = []; 

  final SplayTreeMap _overlays =SplayTreeMap(); 

  Timer? _closeTimer;

  void showMenu({
    required BuildContext context,
    required RuiMenuItem parent,
    required Offset position,
    // required List<RuiMenuItem> items,
    // required void Function(RuiMenuItem, Offset) onHover,
  }) {
    _removeEntriesFromLevel(_entries.length);

    final entry = OverlayEntry(
      builder:
          (context) => Positioned(
            left: position.dx,
            top: position.dy,
            child: MouseRegion(
              onExit: (_) => _removeEntriesFromLevel(_entries.length - 1),
              child: Material(
                elevation: 4,
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        parent.children!.map((item) {
                          return MouseRegion(
                            onEnter: (e) {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              final offset = box.localToGlobal(Offset.zero);
                              final childPosition = Offset(
                                offset.dx + box.size.width  *2/3,
                                offset.dy +( parent.children!.indexOf(item)+0.5)* 40,
                              );
                              if (item.children != null &&
                                  item.children!.isNotEmpty) {
                                // onHover(item, childPosition);
                                showMenu(context: context, parent: item, 
                                position: childPosition );
                              } else {
                                _removeEntriesFromLevel(_entries.length);
                              }
                            },
                            child: MenuItemButton(
                              onPressed: () {
                                item.onTap?.call(item);
                                removeAll();
                              },

                              child: RuiMenuItemWidget(
                                item: item,
                                iconScale: 1,
                                menuIconSize: RuiToolButton.menuItemIconSize,
                                minWidth: RuiToolButton.menuItemMinWidth,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(entry);
    _entries.add(entry);
  }

  void _removeEntriesFromLevel(int level) {
    while (_entries.length > level) {
      _entries.removeLast().remove();
    }
  }

  void _startCloseTimer() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 300), removeAll);
  }

  void _cancelCloseTimer() {
    _closeTimer?.cancel();
  }

  void removeAll() {
    for (final entry in _entries) {
      entry.remove();
    }
    _entries.clear();
    _closeTimer?.cancel();
  }
}
