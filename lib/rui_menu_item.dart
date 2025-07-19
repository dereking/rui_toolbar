import 'package:flutter/material.dart';

typedef MenuEvent = void Function(RuiMenuItem item);

class RuiMenuItem {
  final GlobalKey _key;

  final String id;
  final IconData icon;
  final String title;

  bool active;
  bool? checked;

  final List<String>? params;

  final List<RuiMenuItem>? subItems;
  bool get hasSubItems => subItems != null && subItems!.isNotEmpty;

  RuiMenuItem? parent;

  final VoidCallback? onPressed;

  RuiMenuItem({
    required this.id,
    required this.icon,
    required this.title,
    this.params,
    this.onPressed,
    this.subItems,
    this.active = false,
    this.checked ,
  // }) : _key = GlobalObjectKey(id);
  }) : _key = GlobalKey();


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
    if (subItems==null || subItems!.isEmpty) return;
    subItems?.forEach((e) => e.parent = this);
  }

  
}
