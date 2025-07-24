import 'package:flutter/material.dart';

typedef MenuEvent = void Function(RuiMenuItem item);

class RuiMenuItem with ChangeNotifier {
  final GlobalKey _key;

  final String id;
  final IconData icon;
  final String title;
  final String? tooltip;

  //是否活跃状态。
  bool? _active;
  bool? get active => _active;
  set active(bool? a) {
    _active = a;
    notifyListeners();
  }

  // 是否选中
  bool? _checked;
  bool? get checked => _checked;
  set checked(bool? b) {
    _checked = b;
    notifyListeners();
  }

  final List<String>? params;

  final List<RuiMenuItem>? children;
  bool get hasChildren => children != null && children!.isNotEmpty;

  RuiMenuItem? parent;

  final void Function(RuiMenuItem )? onTap;

  RuiMenuItem({
    required this.id,
    required this.icon,
    required this.title,
    this.tooltip,
    this.params,
    this.onTap,
    this.children,
    bool? active = false,
    bool? checked = false,
  }) : _key = GlobalObjectKey(id) {
    active = active;
    checked = checked;
  } 

  GlobalKey get key => _key;

  bool get hasContext => _key.currentContext != null;

  Offset get position {
    if (_key.currentContext == null) return Offset.zero;

    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;

    return box.localToGlobal(Offset.zero);
  }

  Size get size {
    if (_key.currentContext == null) return Size.zero;

    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;

    return box.size;
  }

  void setParent() {
    if (children == null || children!.isEmpty) return;
    children?.forEach((e) => e.parent = this);
  }
}
