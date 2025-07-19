import 'dart:collection';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'enum.dart';
import 'rui_menu_item.dart';
import 'rui_menu_item_widget.dart';

class RuiToolButton extends StatefulWidget {
  final RuiMenuItem item;

  final bool toolbarVertical;

  final double iconSize;

  final double? width;
  final double? height;

  final TriggerMode triggerMode;
  final MenuButtonStyle buttonStyle;

  static const double padding = 10.0;
  static const double spacer = 5.0;
  static const double textHeight = 24.0;

  static const double itemMinWidth = 150.0;
  static const double itemMinHeight = 24.0;
  // static const double defaultItemSize = 42.0;

  RuiToolButton({
    required this.item,
    required this.iconSize,
    this.width = itemMinWidth,
    this.height = itemMinHeight,
    required this.triggerMode,
    required this.buttonStyle,
    required this.toolbarVertical,
  }) : super(key: item.key);

  @override
  State<RuiToolButton> createState() => _RuiToolButtonState();
}

class _RuiToolButtonState extends State<RuiToolButton> {
  bool _disposed = false;

  final FocusNode _focusNode = FocusNode();

  SplayTreeMap<String, OverlayEntry> _popups = SplayTreeMap();

  Set<String> _hoveredPopupKey = {};

  @override
  void dispose() {
    _disposed = true;

    _hoveredPopupKey.clear();
    _popups.forEach((k, v) => v.remove());
    _popups.clear();

    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      onHover: (value) {
        if (widget.buttonStyle == MenuButtonStyle.iconOnly) {
          showSubMenu(widget.item);
        }
      },
      child: Row(
        children: [
          _buildButton(),
          if (widget.item.hasSubItems &&
              widget.buttonStyle != MenuButtonStyle.iconOnly)
            if (widget.toolbarVertical) Flexible(child: Container()),
          if (widget.item.hasSubItems &&
              widget.buttonStyle != MenuButtonStyle.iconOnly)
            __buildDropdownArrow(() {
              showSubMenu(widget.item);
            }),
        ],
      ),
    );
  }

  Size getSize() {
    switch (widget.buttonStyle) {
      case MenuButtonStyle.iconOnly:
        return Size(
          widget.iconSize + 2 * RuiToolButton.padding,
          max(
            RuiToolButton.itemMinHeight,
            widget.iconSize + 2 * RuiToolButton.padding,
          ),
        );
      case MenuButtonStyle.textFollowIcon:
        return Size(
          max(
            RuiToolButton.itemMinWidth,
            widget.iconSize + 2 * RuiToolButton.padding,
          ),
          max(
            RuiToolButton.itemMinHeight,
            widget.iconSize + 2 * RuiToolButton.padding,
          ),
        );
      case MenuButtonStyle.textOnly:
        return Size(
          max(RuiToolButton.itemMinWidth, 2 * RuiToolButton.padding),
          max(
            RuiToolButton.itemMinHeight,
            widget.iconSize + 2 * RuiToolButton.padding,
          ),
        );
      case MenuButtonStyle.textUnderIcon:
        return Size(
          max(RuiToolButton.itemMinWidth, 2 * RuiToolButton.padding),
          max(
            RuiToolButton.itemMinHeight,
            widget.iconSize +
                2 * RuiToolButton.padding +
                RuiToolButton.spacer +
                RuiToolButton.textHeight,
          ),
        );
    }
    // return
  }

  Widget _buildButton() {
    switch (widget.buttonStyle) {
      case MenuButtonStyle.iconOnly:
        return _buildIconButton();
      case MenuButtonStyle.textFollowIcon:
        return _buildTextFollowIconButton();
      case MenuButtonStyle.textUnderIcon:
        return _buildTextUnderIconButton();
      case MenuButtonStyle.textOnly:
        return _buildTextButton();
    }
  }

  Widget _buildTextButton() {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon(widget.item.icon, size: widget.iconSize),
          // const SizedBox(width: RuiToolButton.spacer),
          Text(widget.item.title),
        ],
      ),
    );
  }

  Widget _buildIconButton() {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Icon(widget.item.icon, size: widget.iconSize),
    );
  }

  Widget __buildDropdownArrow(void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 16,
        height: (widget.height ?? 16) * 2,
        child: const Icon(Icons.arrow_drop_down, size: 16),
      ),
    );
  }

  Widget _buildTextFollowIconButton() {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Row(
        children: [
          Icon(widget.item.icon, size: widget.iconSize),
          const SizedBox(width: RuiToolButton.spacer),
          Text(widget.item.title),
        ],
      ),
    );
  }

  Widget _buildTextUnderIconButton() {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(widget.item.icon, size: widget.iconSize),
          const SizedBox(height: RuiToolButton.spacer),
          Text(widget.item.title),
        ],
      ),
    );
  }

  //for top level button .
  void _onTap() {
    widget.item.onPressed?.call();
  }

  void _showSubMenuDelay(RuiMenuItem menu) {
    Future.delayed(const Duration(milliseconds: 30), () {
      showSubMenu(menu);
    });
  }

  void showSubMenu(RuiMenuItem pMenu) {
    if (pMenu.subItems == null || pMenu.subItems!.isEmpty) {
      return;
    }
    if (_disposed) return;

    _focusNode.requestFocus();

    switch (widget.triggerMode) {
      case TriggerMode.hover:
        _showHoveredPopupMenu(pMenu, context, pMenu.subItems!);
        break;
      case TriggerMode.tap:
        _showTappedSubMenu(pMenu, context, pMenu.subItems!);
        break;
    }
  }

  void _showHoveredPopupMenu(
    RuiMenuItem menu,
    BuildContext context,
    List<RuiMenuItem> menuItems,
  ) {
    if (_disposed) return;
    if (_popups.containsKey(menu.key.toString())) return;

    if (menuItems.isEmpty) return;

    //
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // print("${overlay.size},${overlay.constraints}");

    final Offset menuPosition = menu.position - const Offset(0, -1);

    print(menuPosition);

    print(menu.size);
    final Size menuSize = menu.size;
    final bool rootMenu = menu.parent == null;
    // final Offset positionOffset = rootMenu
    //     ? Offset(5, widget.height ?? RuiToolButton.defaultItemSize)
    //     : Offset(menuSize.width - 10, 10);
    final Offset positionOffset = rootMenu ? Offset(0, 0) : Offset(0, 10);

    Offset position = menuPosition + positionOffset;
    double? top = position.dy;
    double? left = position.dx;
    double? right;
    double? bottom;

    print(position);

    if (position.dx + RuiToolButton.itemMinWidth > overlay.size.width) {
      if (rootMenu) {
        left = null;
        right = 0;
      } else {
        left = null;
        right = overlay.size.width - menuPosition.dx;
        if (right + menuSize.width >= overlay.size.width) {
          top = menuPosition.dy + 30;
          bottom = null;
          left = menuPosition.dx <= 15 ? menuPosition.dx + 10 : 0;
          right = null;
        }
      }
    }

    if (position.dy + RuiToolButton.itemMinHeight * menuItems.length >
        overlay.size.height) {
      if (rootMenu) {
        top = null;
        bottom = 0;
      } else {
        top = null;
        bottom = overlay.size.height - menuPosition.dy;
        if (bottom + menuSize.height >= overlay.size.height) {
          top = menuPosition.dy + 30;
          bottom = null;
          top = menuPosition.dy <= 15 ? menuPosition.dy + 10 : 0;
          bottom = null;
        }
      }
    }
    __buildSubmenu(menu, left, top, right, bottom, overlay);
    Overlay.of(context).insert(_popups[menu.key.toString()]!);
  }

  void _showTappedSubMenu(
    RuiMenuItem menu,
    BuildContext context,
    List<RuiMenuItem> menuItems,
  ) {
    _showHoveredPopupMenu(menu, context, menuItems);
  }

  void __buildSubmenu(
    RuiMenuItem menu,
    double? left,
    double? top,
    double? right,
    double? bottom,
    RenderBox overlay,
  ) {
    _popups[menu.key.toString()] = OverlayEntry(
      builder: (_) {
        Widget buildItemWidget(RuiMenuItem item) {
          Widget aMenuItem = MenuItemButton(
            onPressed: () {
              if (item.hasSubItems) {
                _showSubMenuDelay(item);
              }
              item.onPressed?.call();
            },
            child: RuiMenuItemWidget(
              item: item,
              iconScale: 1,
              menuIconSize: 32,
            ),
          );

          return aMenuItem;
        }

        final menuItemWidgets = menu.subItems!.map(buildItemWidget).toList();

        return Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Material(
            child: Focus(
              focusNode: _focusNode,
              onFocusChange: (hasFocus) {
                if (!hasFocus) {
                  // _removeOverlay();
                  _removeHoveredPopupKey(menu);
                }
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: min(overlay.size.width, RuiToolButton.itemMinWidth),
                  maxWidth: overlay.size.width,
                  maxHeight: overlay.size.height - (top ?? 0),
                ),
                child: PhysicalModel(
                  color: Theme.of(context).colorScheme.surface,
                  elevation: 1.0,
                  child: MouseRegion(
                    onHover: (PointerHoverEvent e) {
                      //TODO:
                      _addHoveredPopupKey(menu);
                      _showSubMenuDelay(menu);
                    },
                    onExit: (PointerExitEvent w) {
                      //TODO:
                      _removeHoveredPopupKey(menu);
                    },
                    child: IntrinsicWidth(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: menuItemWidgets,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addHoveredPopupKey(RuiMenuItem menu, {bool addSelf = true}) {
    if (addSelf) _hoveredPopupKey.add(menu.key.toString());

    var current = menu.parent;
    while (current != null) {
      _hoveredPopupKey.add(current.key.toString());
      current = current.parent;
    }
  }

  // 移除
  void _removeHoveredPopupKey(RuiMenuItem menu) {
    _hoveredPopupKey.clear();

    Future.delayed(const Duration(milliseconds: 60), () {
      if (!_hoveredPopupKey.contains(menu.key.toString())) {
        _popups[menu.key.toString()]?.remove();
        _popups.remove(menu.key.toString());
      }

      if (_hoveredPopupKey.isEmpty) {
        _popups.forEach((k, v) => v.remove());
        _popups.clear();
      }
    });
  }
}
