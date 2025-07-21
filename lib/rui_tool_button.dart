import 'dart:collection';
import 'dart:math';
import 'dart:ui';

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
  // final double? height;

  final TriggerMode triggerMode;
  final MenuButtonStyle buttonStyle;

  static const double padding = 10.0;
  static const double spacer = 5.0;
  static const double textHeight = 24.0;

  static const double defaultButtonWidth = 150.0;
  // static const double itemMinWidth = 150.0;
  // static const double itemMinHeight = 24.0;
  // static const double defaultItemSize = 42.0;

  static const double menuItemIconSize = 16.0;
  static const double menuItemMinWidth = 120.0;

  RuiToolButton({
    required this.item,
    required this.iconSize,
    this.width = defaultButtonWidth,
    // this.height = itemMinHeight,
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
  void initState() {
    super.initState();
    // _width = widget.width ?? RuiToolButton.itemMinWidth;
    // _height = widget.height ?? RuiToolButton.itemMinHeight;
  }

  @override
  void didUpdateWidget(RuiToolButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _width = widget.width ?? RuiToolButton.itemMinWidth;
    // _height = widget.height ?? RuiToolButton.itemMinHeight;
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
      child: Tooltip(
        message: widget.item.tooltip ?? widget.item.title,
        child:
            widget.toolbarVertical
                ? _buildButtonInVertical()
                : _buildButtonNormal(),
      ),
    );
  }

  Widget _buildButtonNormal() {
    return Row(
      mainAxisAlignment: getMainAxisAlignment(),
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildButtonContent(false),
        if (widget.item.hasSubItems &&
            widget.buttonStyle != MenuButtonStyle.iconOnly)
          if (widget.toolbarVertical) Container(),
        if (widget.item.hasSubItems &&
            widget.buttonStyle != MenuButtonStyle.iconOnly)
          __buildDropdownArrow(() {
            showSubMenu(widget.item);
          }),
      ],
    );
  }

  Widget _buildButtonInVertical() {
    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          _buildButtonContent(true),
          if (widget.item.hasSubItems &&
              widget.buttonStyle != MenuButtonStyle.iconOnly)
            __buildDropdownArrow(() {
              showSubMenu(widget.item);
            }),
        ],
      ),
      // child: Row(
      //   mainAxisAlignment: getMainAxisAlignment(),
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     _buildButtonContent(true),
      //     if (widget.item.hasSubItems &&
      //         widget.buttonStyle != MenuButtonStyle.iconOnly)
      //       if (widget.toolbarVertical) Spacer(),
      //     if (widget.item.hasSubItems &&
      //         widget.buttonStyle != MenuButtonStyle.iconOnly)
      //       __buildDropdownArrow(() {
      //         showSubMenu(widget.item);
      //       }),
      //   ],
      // ),
    );
  }

  MainAxisAlignment getMainAxisAlignment() {
    if (widget.toolbarVertical) {
      switch (widget.buttonStyle) {
        case MenuButtonStyle.iconOnly:
          return MainAxisAlignment.center;
        case MenuButtonStyle.textFollowIcon:
          return MainAxisAlignment.start;
        case MenuButtonStyle.textUnderIcon:
          return MainAxisAlignment.center;
      }
    }

    switch (widget.buttonStyle) {
      case MenuButtonStyle.iconOnly:
        return MainAxisAlignment.center;
      case MenuButtonStyle.textFollowIcon:
        return MainAxisAlignment.start;
      case MenuButtonStyle.textUnderIcon:
        return MainAxisAlignment.center;
    }
  }

  Widget _buildButtonContent(bool flexWidth) {
    switch (widget.buttonStyle) {
      case MenuButtonStyle.iconOnly:
        return _buildIconButton();
      case MenuButtonStyle.textFollowIcon:
        return _buildTextFollowIconButton(flexWidth);
      case MenuButtonStyle.textUnderIcon:
        return _buildTextUnderIconButton(flexWidth);
    }
  }

  Widget _buildIconButton() {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Icon(widget.item.icon, size: widget.iconSize),
    );
  }

  Widget __buildDropdownArrow(void Function()? onTap) {
    return Align(
      alignment: Alignment.centerRight, // 可选：设置垂直位置
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 16,
          // height: (widget.height ?? 16) * 2,
          child: const Icon(Icons.arrow_drop_down, size: 16),
        ),
      ),
    );
  }

  Widget _buildTextFollowIconButton(bool flexWidth) {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Row(
        children: [
          Icon(widget.item.icon, size: widget.iconSize),
          const SizedBox(width: RuiToolButton.spacer),
          SizedBox(
            width:
                widget.width != null
                    ? (widget.width! -
                        RuiToolButton.spacer -
                        2 * RuiToolButton.padding -
                        widget.iconSize)
                    : null,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(widget.item.title),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextUnderIconButton(bool flexWidth) {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(widget.item.icon, size: widget.iconSize),
          const SizedBox(height: RuiToolButton.spacer),
          FittedBox(child: Text(widget.item.title)),
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

    // 获取覆盖层的RenderBox对象,用于计算菜单位置
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // 计算菜单的初始位置
    // 对menu.position进行微调,向上偏移1个单位
    final Offset menuPosition = menu.position - const Offset(0, -1);

    // print(menuPosition);

    // print(menu.size);
    // 获取菜单项的尺寸
    final Size menuSize = menu.size;
    // 判断是否为根菜单(顶层菜单)
    final bool rootMenu = menu.parent == null;
    // 计算位置偏移量
    // 根菜单: 向右偏移5,向下偏移菜单高度
    // 子菜单:
    final Offset positionOffset =
        rootMenu
            ? Offset(5, menuSize.height)
            : Offset(menuSize.width *2/3 , menuSize.height *2/ 3);
    // print(" cal offset rootMenu=$rootMenu, positionOffset=$positionOffset");

    // 计算最终的菜单显示位置
    Offset position = menuPosition + positionOffset;
    double? top = position.dy;
    double? left = position.dx;
    double? right;
    double? bottom;

    // print("menuPosition position= $position, overlay.size=${overlay.size}");

    // 处理水平方向溢出
    // 如果菜单右边界超出屏幕
    if (position.dx + RuiToolButton.defaultButtonWidth > overlay.size.width) {
      if (rootMenu) {
        // 根菜单靠右对齐
        left = null;
        right = 0;
      } else {
        // 子菜单向左展开
        left = null;
        right = overlay.size.width - menuPosition.dx;
        // 如果左边也放不下,则向下展开
        if (right + menuSize.width >= overlay.size.width) {
          top = menuPosition.dy + 30;
          bottom = null;
          // 如果靠左边距离太小,则稍微右移
          left = menuPosition.dx <= 15 ? menuPosition.dx + 10 : 0;
          right = null;
        }
      }
    }

    // 处理垂直方向溢出
    // 如果菜单底部超出屏幕
    if (position.dy + 24 * menuItems.length > overlay.size.height) {
      if (rootMenu) {
        // 根菜单靠底对齐
        top = null;
        bottom = 0;
      } else {
        // 子菜单向上展开
        top = null;
        bottom = overlay.size.height - menuPosition.dy;
        // 如果上面也放不下,则调整到合适位置
        if (bottom + menuSize.height >= overlay.size.height) {
          top = menuPosition.dy + 30;
          bottom = null;
          // 如果靠上边距离太小,则稍微下移
          top = menuPosition.dy <= 15 ? menuPosition.dy + 10 : 0;
          bottom = null;
        }
      }
    }
    // 构建子菜单
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
          item.parent = menu;
          Widget aMenuItem = MenuItemButton(
            key: item.key,
            onHover: (onHover) {
              if (item.hasSubItems) {
                _showSubMenuDelay(item);
              }
            },
            onPressed: () {
              if (item.hasSubItems) {
                _showSubMenuDelay(item);
              }
              item.onPressed?.call();
            },
            child: RuiMenuItemWidget(
              item: item,
              iconScale: 1,
              menuIconSize: RuiToolButton.menuItemIconSize,
              minWidth: RuiToolButton.menuItemMinWidth,
            ),
          );

          return aMenuItem;
        }

        final menuItemWidgets = menu.subItems!.map(buildItemWidget).toList();
        // print("top=$top, left=$left,$right=right, $bottom=bottom");
        return Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Material(
            child:   ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: RuiToolButton.menuItemMinWidth,
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
          
        );
      },
    );
  }

  /// 添加悬停菜单项的key到_hoveredPopupKey集合中
  /// 同时也会添加其所有父级菜单项的key
  /// [menu] 当前菜单项
  /// [addSelf] 是否添加自身的key,默认为true
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

class ClipperRect extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
