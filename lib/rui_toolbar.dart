import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'enum.dart';
import 'rui_menu_item.dart';
import 'rui_tool_button.dart';

class RuiToolbar extends StatefulWidget {
  // final String id;
  final List<RuiMenuItem> items;
  final double? height;
  final double? width;
  final TriggerMode triggerMode;

  final bool vertical;
  final MenuButtonStyle buttonStyle;

  final bool enableSelectedTopMenu;
  final int? initialSelectedTopMenuIndex;

  // 图标大小
  final double iconSize;

  static const padding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  const RuiToolbar({
    super.key,
    // required this.id,
    required this.items,
    this.iconSize = 28,
    this.vertical = false,
    this.height = 40,
    this.width = 120,
    this.triggerMode = TriggerMode.hover,
    this.buttonStyle = MenuButtonStyle.textFollowIcon,
    this.enableSelectedTopMenu = false,
    this.initialSelectedTopMenuIndex = 0,
  });

  @override
  State<RuiToolbar> createState() => _RuiToolbarState();
}

class _RuiToolbarState extends State<RuiToolbar> {
  GlobalKey<State<StatefulWidget>>? _selectedMenuKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, size) {
        return SizedBox(
          width: widget.vertical
              ? (widget.buttonStyle == MenuButtonStyle.iconOnly
                    ? widget.iconSize + 2 * RuiToolButton.padding
                    : widget.width)
              : double.infinity,
          height: widget.vertical
              ? double.infinity
              : (widget.buttonStyle == MenuButtonStyle.iconOnly ||
                        widget.buttonStyle == MenuButtonStyle.textOnly
                    ? widget.iconSize + 2 * RuiToolButton.padding
                    : (widget.buttonStyle == MenuButtonStyle.textUnderIcon
                          ? widget.iconSize +
                                2 * RuiToolButton.padding +
                                RuiToolButton.textHeight +
                                RuiToolButton.spacer
                          : (widget.buttonStyle == MenuButtonStyle.textOnly
                                ? 2 * RuiToolButton.padding +
                                      RuiToolButton.textHeight
                                : widget.height))),
          child: Ink(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: ListView.builder(
                scrollDirection: widget.vertical
                    ? Axis.vertical
                    : Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return RuiToolButton(
                    item: widget.items[index],
                    toolbarVertical: widget.vertical,
                    iconSize: widget.iconSize,
                    // height: widget.vertical? null:  widget.height,
                    width: widget.vertical ? widget.width : null,
                    triggerMode: widget.triggerMode,
                    buttonStyle: widget.buttonStyle,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
