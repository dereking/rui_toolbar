import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rui_toolbar/rui_menu_item.dart';
import 'package:rui_toolbar/rui_menu_item_widget.dart';

class RuiToolMenuController {
  // 私有构造函数
  RuiToolMenuController._internal();

  // 单例实例
  static final RuiToolMenuController _instance =
      RuiToolMenuController._internal();

  // 工厂构造函数
  factory RuiToolMenuController() {
    return _instance;
  }

  final SplayTreeMap _popups = SplayTreeMap<String, RuiToolMenuOverlay>();
  String _currentKey = "";

  void log(String msg) {
    print("--------$msg");
    _popups.forEach((key, overlay) {
      print(key);
    });
  }

  Future<void> showSubMenu(BuildContext context, RuiMenuItem item) async {
    if (_currentKey == item.key.toString() || item.children == null) {
      return;
    }

    log("showSubMenu");

    RuiToolMenuOverlay? oe =
        _popups[item.key.toString()] as RuiToolMenuOverlay?;
    if (oe == null) {
      oe = RuiToolMenuOverlay(context, item);
      oe.init();

      _popups[item.key.toString()] = oe;
    }
    Overlay.of(context).insert(oe.overlay!);
    _currentKey = item.key.toString();

    log("showSubMenu ok");
  }

  // level: 需要保留截止的层级
  void hideToLevel(int level) {
    // 遍历所有弹出菜单
    List<String> toRemove = [];
    _popups.forEach((key, overlay) {
      // 获取菜单层级
      int itemLevel = overlay.item.level;
      // 如果菜单层级大于指定层级,则移除该菜单
      if (itemLevel > level) {
        overlay.overlay?.remove();
        toRemove.add(key);
      }
    });

    for (var key in toRemove) {
      _popups.remove(key);
    }

    log("hide to $level");
  }

  void hideAll() {
    // 遍历所有弹出菜单
    _popups.forEach((key, overlay) {
      overlay.overlay?.remove();
    });
    _popups.clear();
    log("hide all");
  }
}

class RuiToolMenuOverlay {
  final RuiMenuItem item;

  BuildContext context;
  RuiToolMenuOverlay(this.context, this.item);

  double? left;
  double? top;
  double? right;
  double? bottom;
  double minWidth = 150;
  double maxHeight = 40;

  double defaultButtonWidth = 120;

  double menuItemIconSize = 24;
  double menuItemMinWidth = 120;

  OverlayEntry? overlay;

  void init() {
    overlay = _newOverlay(item);
  }

  void _calSize(RuiMenuItem item) {
    if (item.key.currentState == null) {
      print("error item.key.currentState is null");
      return;
    }
    if (item.children == null) return;

    // 获取菜单项的RenderBox对象
    // final RenderBox itemRenderBox = item.key.currentContext!.findRenderObject() as RenderBox; 

    // 获取覆盖层的RenderBox对象,用于计算菜单位置
    final RenderBox box =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    // 计算菜单的初始位置
    // 对menu.position进行微调,向上偏移1个单位
    final Offset menuPosition = item.position - const Offset(0, -1);

    // print(menuPosition);

    // print(menu.size);
    // 获取菜单项的尺寸
    final Size menuSize = item.size;
    // 判断是否为根菜单(顶层菜单)
    final bool rootMenu = item.parent == null;
    // 计算位置偏移量
    // 根菜单: 向右偏移5,向下偏移菜单高度
    // 子菜单:
    final Offset positionOffset = rootMenu
        ? Offset(5, menuSize.height)
        : Offset(menuSize.width * 2 / 3, menuSize.height * 2 / 3);
    // print(" cal offset rootMenu=$rootMenu, positionOffset=$positionOffset");

    // 计算最终的菜单显示位置
    Offset position = menuPosition + positionOffset;
    top = position.dy;
    left = position.dx;

    // print("menuPosition position= $position, overlay.size=${overlay.size}");

    // 处理水平方向溢出
    // 如果菜单右边界超出屏幕
    if (position.dx + defaultButtonWidth > box.size.width) {
      if (rootMenu) {
        // 根菜单靠右对齐
        left = null;
        right = 0;
      } else {
        // 子菜单向左展开
        left = null;
        right = box.size.width - menuPosition.dx;
        // 如果左边也放不下,则向下展开
        if (right! + menuSize.width >= box.size.width) {
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
    if (position.dy + 24 * item.children!.length > box.size.height) {
      if (rootMenu) {
        // 根菜单靠底对齐
        top = null;
        bottom = 0;
      } else {
        // 子菜单向上展开
        top = null;
        bottom = box.size.height - menuPosition.dy;
        // 如果上面也放不下,则调整到合适位置
        if (bottom! + menuSize.height >= box.size.height) {
          top = menuPosition.dy + 30;
          bottom = null;
          // 如果靠上边距离太小,则稍微下移
          top = menuPosition.dy <= 15 ? menuPosition.dy + 10 : 0;
          bottom = null;
        }
      }
    }

    maxHeight = box.size.height - (top ?? 0);
  }

  OverlayEntry? _newOverlay(RuiMenuItem item) {
    if (item.children == null) {
      return null;
    }
    _calSize(item);

    return OverlayEntry(
      builder: (_) {
        return Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Material(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: minWidth,
                maxHeight: maxHeight,
              ),
              child: PhysicalModel(
                color: Theme.of(context).colorScheme.surface,
                elevation: 1.0,
                child: MouseRegion(
                  onHover: (PointerHoverEvent e) {},
                  child: _buildMenuList(item),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuList(RuiMenuItem parent) {
    if (parent.children == null) {
      return Text("empty menu items");
    }

    final menuItemWidgets = parent.children!.map((subItem) {
      // print(" buildItemWidget subItem=${subItem.title}");
      subItem.parent = parent;
      Widget aMenuItem = MenuItemButton(
        onHover: (onHover) {
          if (subItem.hasChildren) {
            // 显示subItem的子菜单
            // _showSubMenuDelay(subItem);
            RuiToolMenuController().showSubMenu(context, subItem);
          } else {
            //取消所有popup，除非是当前的menu弹出的
            // updateOverlayLinks(parent, null);
            RuiToolMenuController().hideToLevel(subItem.level);
          }
        },
        onPressed: () {
          RuiToolMenuController().hideAll();

          //trigger item event
          subItem.onTap?.call(subItem);

          //show submenu
          if (subItem.hasChildren) {
            // 显示subItem的子菜单
            RuiToolMenuController().showSubMenu(context, subItem);
          }
        },
        child: RuiMenuItemWidget(
          item: subItem,
          iconScale: 1,
          menuIconSize: menuItemIconSize,
          minWidth: menuItemMinWidth,
        ),
      );

      return aMenuItem;
    }).toList();
    return IntrinsicWidth(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: menuItemWidgets,
        ),
      ),
    );
  }
}
