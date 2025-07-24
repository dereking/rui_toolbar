import 'dart:async';
import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rui_toolbar/recursive_menu_controller.dart';

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

  final void Function(RuiMenuItem item)? onToolItemSelect;

  //
  // static final LinkedList _popupLink = LinkedList<OverlayKeyLinkNode>();

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
    this.onToolItemSelect,
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
  static final RecursiveMenuController controller = RecursiveMenuController();

  bool _disposed = false;

  final FocusNode _focusNode = FocusNode();

  // final SplayTreeMap<String, OverlayEntry> _popups = SplayTreeMap();
  // final Set<String> _hoveredPopupKey = {};

  @override
  void dispose() {
    _disposed = true;

    // 遍历链表删除所有节点的o
    // OverlayKeyLinkNode? node =
    //     RuiToolButton._popupLink.first as OverlayKeyLinkNode;
    // while (node != null) {
    //   node.overlay.remove();
    //   node = node.next;
    // }
    // RuiToolButton._popupLink.clear();

    // _hoveredPopupKey.clear();

    // _popups.forEach((k, v) => v.remove());
    // _popups.clear();

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
    // 工具栏上的button
    return ChangeNotifierProvider<RuiMenuItem>.value(
      value: widget.item,
      child: Consumer<RuiMenuItem>(
        builder: (BuildContext context, RuiMenuItem root, Widget? child) {
          return InkWell(
            onTap: () {
              _onTap(root);
            },
            onHover: (value) {
              if (widget.buttonStyle == MenuButtonStyle.iconOnly) {
                showSubMenu(root);
              }
            },
            child: Tooltip(
              message: root.tooltip ?? root.title,
              child:
                  widget.toolbarVertical
                      ? _buildButtonInVertical(root)
                      : _buildButtonNormal(root),
            ),
          );
        },
      ),
    );
  }

  Widget _buildButtonNormal(RuiMenuItem item) {
    return Row(
      mainAxisAlignment: getMainAxisAlignment(),
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildButtonContent(item, false),
        if (item.hasChildren && widget.buttonStyle != MenuButtonStyle.iconOnly)
          if (widget.toolbarVertical) Container(),
        if (item.hasChildren && widget.buttonStyle != MenuButtonStyle.iconOnly)
          __buildDropdownArrow(() {
            showSubMenu(item);
          }),
      ],
    );
  }

  Widget _buildButtonInVertical(RuiMenuItem item) {
    return SizedBox(
      width: widget.width,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          _buildButtonContent(item, true),
          if (item.hasChildren &&
              widget.buttonStyle != MenuButtonStyle.iconOnly)
            __buildDropdownArrow(() {
              showSubMenu(item);
            }),
        ],
      ),
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

  Widget _buildButtonContent(RuiMenuItem item, bool flexWidth) {
    switch (widget.buttonStyle) {
      case MenuButtonStyle.iconOnly:
        return _buildIconButton(item);
      case MenuButtonStyle.textFollowIcon:
        return _buildTextFollowIconButton(item, flexWidth);
      case MenuButtonStyle.textUnderIcon:
        return _buildTextUnderIconButton(item, flexWidth);
    }
  }

  Widget _buildIconButton(RuiMenuItem item) {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Icon(item.icon, size: widget.iconSize),
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

  Widget _buildTextFollowIconButton(RuiMenuItem item, bool flexWidth) {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Row(
        children: [
          Icon(item.icon, size: widget.iconSize),
          const SizedBox(width: RuiToolButton.spacer),
          SizedBox(
            width:
                widget.width != null
                    ? (widget.width! -
                        RuiToolButton.spacer -
                        2 * RuiToolButton.padding -
                        widget.iconSize)
                    : null,
            child: FittedBox(fit: BoxFit.scaleDown, child: Text(item.title)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextUnderIconButton(RuiMenuItem item, bool flexWidth) {
    return Padding(
      padding: const EdgeInsets.all(RuiToolButton.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(item.icon, size: widget.iconSize),
          const SizedBox(height: RuiToolButton.spacer),
          FittedBox(child: Text(item.title)),
        ],
      ),
    );
  }

  //for top level button .
  void _onTap(RuiMenuItem item) {
    widget.onToolItemSelect?.call(item);

    item.onTap?.call(item);
  }

  void _showSubMenuDelay(RuiMenuItem parent) {
    Future.delayed(const Duration(milliseconds: 30), () {
      showSubMenu(parent);
    });
  }

  void showSubMenu(RuiMenuItem parent) {
    if (parent.children == null || parent.children!.isEmpty) {
      return;
    }
    if (_disposed) return;

    _focusNode.requestFocus();

    switch (widget.triggerMode) {
      case TriggerMode.hover:
        _showHoveredPopupMenu(parent, context);
        break;
      case TriggerMode.tap:
        _showTappedSubMenu(parent, context);
        break;
    }
  }

  void _showHoveredPopupMenu(RuiMenuItem parent, BuildContext context) {
    if (_disposed) return;
    // if (_popups.containsKey(parent.key.toString())) return;

    if (parent.children == null || parent.children!.isEmpty) return;

    // _removeEntriesFromLevel(_entries.length);

    // 获取覆盖层的RenderBox对象,用于计算菜单位置
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // 计算菜单的初始位置
    // 对menu.position进行微调,向上偏移1个单位
    final Offset menuPosition = parent.position - const Offset(0, -1);

    // print(menuPosition);

    // print(menu.size);
    // 获取菜单项的尺寸
    final Size menuSize = parent.size;
    // 判断是否为根菜单(顶层菜单)
    final bool rootMenu = parent.parent == null;
    // 计算位置偏移量
    // 根菜单: 向右偏移5,向下偏移菜单高度
    // 子菜单:
    final Offset positionOffset =
        rootMenu
            ? Offset(5, menuSize.height)
            : Offset(menuSize.width * 2 / 3, menuSize.height * 2 / 3);
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
    if (position.dy + 24 * parent.children!.length > overlay.size.height) {
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
    final OverlayEntry? oe = __buildSubmenuOverlayEntry(
      parent,
      left,
      top,
      right,
      bottom,
      overlay,
    );

    if (oe != null) {
      //记录当前级别的key到链表。
      // updateOverlayLink(parent, oe);

      Overlay.of(context).insert(oe);
    }
  }

  void updateOverlayLink(RuiMenuItem parent, OverlayEntry oe) {
    // 从当前item开始向上遍历parent，构建key列表
    // List<String> parentKeys = [];
    // RuiMenuItem? current = parent;
    // while (current != null) {
    //   parentKeys.insert(0, current.key.toString());
    //   current = current.parent;
    // }

    // // 检查现有链表中的节点是否与parentKeys一一对应
    // var node = RuiToolButton._popupLink.first as OverlayKeyLinkNode;
    // int matchedCount = 0;

    // // 遍历链表，直到找到不匹配的节点或达到parentKeys长度
    // while (matchedCount < parentKeys.length) {
    //   if (node.key != parentKeys[matchedCount]) {
    //     break;
    //   }
    //   matchedCount++;
    //   node = node.next as OverlayKeyLinkNode;
    // }

    // // 移除不匹配的后续节点
    // while (RuiToolButton._popupLink.length > matchedCount) {
    //   RuiToolButton._popupLink.remove(RuiToolButton._popupLink.last);
    // }

    // // 添加新的key节点
    // for (int i = matchedCount; i < parentKeys.length; i++) {
    //   RuiToolButton._popupLink.add(OverlayKeyLinkNode(parentKeys[i], oe));
    // }
  }

  void _showTappedSubMenu(RuiMenuItem parent, BuildContext context) {
    _showHoveredPopupMenu(parent, context);
  }

  OverlayEntry? __buildSubmenuOverlayEntry(
    RuiMenuItem parent,
    double? left,
    double? top,
    double? right,
    double? bottom,
    RenderBox overlay,
  ) {
    if (parent.children == null || parent.children!.isEmpty) {
      return null;
    }

    final ret = OverlayEntry(
      builder: (_) {
        Widget buildItemWidget(RuiMenuItem subItem) {
          // print(" buildItemWidget subItem=${subItem.title}");
          subItem.parent = parent;
          Widget aMenuItem = MenuItemButton(
            key: subItem.key,
            onHover: (onHover) {
              if (subItem.hasChildren) {
                // 显示subItem的子菜单
                _showSubMenuDelay(subItem);
              }
            },
            onPressed: () {
              // trigger top event.
              widget.onToolItemSelect?.call(subItem);

              //trigger item event
              subItem.onTap?.call(subItem);

              //show submenu
              if (subItem.hasChildren) {
                // 显示subItem的子菜单
                _showSubMenuDelay(subItem);
              }
            },
            child: RuiMenuItemWidget(
              item: subItem,
              iconScale: 1,
              menuIconSize: RuiToolButton.menuItemIconSize,
              minWidth: RuiToolButton.menuItemMinWidth,
            ),
          );

          return aMenuItem;
        }

        final menuItemWidgets = parent.children!.map(buildItemWidget).toList();

        // for (var sub in parent.children!) {
        //   print("sub = ${sub.id} ${sub.title}");
        // }
        // for (var w in menuItemWidgets) {
        //   print("menuItemWidgets = ${w.toString()}");
        // }
        // print("parent = ${parent.id} ${parent.title}");
        // print("top=$top, left=$left,$right=right, $bottom=bottom");
        return ChangeNotifierProvider.value(
          value: parent,
          child: Positioned(
            top: top,
            left: left,
            right: right,
            bottom: bottom,
            child: Material(
              child: ConstrainedBox(
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
                      // _addHoveredPopupKey(parent);

                      // 显示子菜单
                      _showSubMenuDelay(parent);
                    },
                    onExit: (PointerExitEvent w) {
                      //TODO:
                      // _removeHoveredPopupKey(parent);
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

    // _popups[parent.key.toString()] = ret;

    return ret;
  }

  /// 添加悬停菜单项的key到_hoveredPopupKey集合中
  /// 同时也会添加其所有父级菜单项的key
  /// [menu] 当前菜单项
  /// [addSelf] 是否添加自身的key,默认为true
  // void _addHoveredPopupKey(RuiMenuItem menu, {bool addSelf = true}) {
  //   if (addSelf) _hoveredPopupKey.add(menu.key.toString());

  //   var current = menu.parent;
  //   while (current != null) {
  //     _hoveredPopupKey.add(current.key.toString());
  //     current = current.parent;
  //   }
  // }

  // 移除
  // void _removeHoveredPopupKey(RuiMenuItem menu) {
  //   _hoveredPopupKey.clear();

  //   Future.delayed(const Duration(milliseconds: 60), () {
  //     // 如果当前菜单项不在悬停状态,移除其对应的弹出菜单
  //     if (!_hoveredPopupKey.contains(menu.key.toString())) {
  //       _popups[menu.key.toString()]?.remove();
  //       _popups.remove(menu.key.toString());
  //     }

  //     // 如果没有任何菜单项处于悬停状态,清除所有弹出菜单
  //     if (_hoveredPopupKey.isEmpty) {
  //       _popups.forEach((k, v) => v.remove());
  //       _popups.clear();
  //     }
  //   });

  // // 从当前menu开始向上遍历parent，构建祖先key列表
  // List<String> ancestorKeys = [];
  // RuiMenuItem? current = menu;
  // while (current != null) {
  //   ancestorKeys.insert(0, current.key.toString());
  //   current = current.parent;
  // }

  // // 遍历链表，检查现有节点是否与ancestorKeys一一对应
  // var node = RuiToolButton._popupLink.first as OverlayKeyLinkNode?;
  // int matchCount = 0;

  // while (node != null && matchCount < ancestorKeys.length) {
  //   if (node.key != ancestorKeys[matchCount]) {
  //     break;
  //   }
  //   matchCount++;
  //   node = node.next  ;
  // }

  // // 移除不匹配的后续节点
  // while (RuiToolButton._popupLink.length > matchCount) {
  //   var a= RuiToolButton._popupLink.last as OverlayKeyLinkNode?;

  //   a?.overlay.remove();

  //   RuiToolButton._popupLink.remove(a!);
  // }

  //   }
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
