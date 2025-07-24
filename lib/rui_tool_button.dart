 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rui_toolbar/overlay_key_link_node.dart';
import 'package:rui_toolbar/rui_tool_menu_controller.dart';

import 'enum.dart';
import 'rui_menu_item.dart'; 

class RuiToolButton extends StatefulWidget {
  final RuiMenuItem item;

  final bool toolbarVertical;

  final double iconSize;

  final double? width;
  // final double? height;

  final TriggerMode triggerMode;
  final MenuButtonStyle buttonStyle;

  final void Function(RuiMenuItem item)? onToolItemSelect;
 

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
  bool _disposed = false;

  final FocusNode _focusNode = FocusNode();

  // final SplayTreeMap<String, OverlayEntry> _popups = SplayTreeMap();
  // final Set<String> _hoveredPopupKey = {};

  @override
  void dispose() {
    _disposed = true;
 

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
                // showSubMenu(root);
                RuiToolMenuController().showSubMenu(context ,root);
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
                RuiToolMenuController().showSubMenu(context ,item);
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
                RuiToolMenuController().showSubMenu(context ,item);
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
    RuiToolMenuController().hideAll();

    widget.onToolItemSelect?.call(item);

    item.onTap?.call(item);
  }
 
 
}
