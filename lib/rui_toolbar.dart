import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'enum.dart';
import 'rui_menu_item.dart';
import 'rui_tool_button.dart';

class RuiToolbar extends StatefulWidget {
  // final String id;
  final List<RuiMenuItem> items;
  // final double? height;
  // final double? width;
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
    this.iconSize = 16,
    this.vertical = false,
    // this.height = 40,
    // this.width = 120,
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
    // return ScrollConfiguration(
    //   behavior: ScrollConfiguration.of(context).copyWith(
    //     dragDevices: {
    //       PointerDeviceKind.touch,
    //       PointerDeviceKind.mouse,
    //       PointerDeviceKind.trackpad,
    //     },
    //     scrollbars: false,
    //   ),
    //   child: SingleChildScrollView(
    //     scrollDirection: widget.vertical ? Axis.vertical : Axis.horizontal,
    //     child: Ink(
    //       color: Theme.of(context).colorScheme.primaryContainer,
    //      child: _buildButtons(),) ,
    //   ),
    // );
    return LayoutBuilder(
      builder: (ctx, size) {
        return SizedBox(
          width: getWidth(),
          height: getHeight(),
          child: Ink(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
                scrollbars: false,
              ),
              child: ListView.builder(
                scrollDirection:
                    widget.vertical ? Axis.vertical : Axis.horizontal,
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  return RuiToolButton(
                    item: widget.items[index],
                    toolbarVertical: widget.vertical,
                    iconSize: widget.iconSize,
                    // height: widget.vertical ? null : widget.height,
                    width: widget.vertical ? getWidth() : null,
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

  double getWidth() {
    // 垂直布局时根据按钮样式计算宽度，否则返回无限宽度
    if (!widget.vertical) return double.infinity;
    
    return widget.buttonStyle == MenuButtonStyle.iconOnly 
        ? widget.iconSize + 2 * RuiToolButton.padding
        : 120;
  }

  double getHeight() {
    if (widget.vertical) return double.infinity;

    // 根据不同按钮样式计算高度
    switch (widget.buttonStyle) {
      case MenuButtonStyle.iconOnly: 
      case MenuButtonStyle.textFollowIcon:
        return widget.iconSize + 2 * RuiToolButton.padding;
      
      case MenuButtonStyle.textUnderIcon:
        return widget.iconSize + 
               2 * RuiToolButton.padding + 
               RuiToolButton.textHeight + 
               RuiToolButton.spacer; 
   
    }
  }

  Widget _buildButtons() {
    final btns =
        widget.items
            .map(
              (item) => SizedBox(
                width: getWidth(), // 撑满一整行
                child: RuiToolButton(
                  item: item,
                  toolbarVertical: widget.vertical,
                  iconSize: widget.iconSize,
                  // height: widget.vertical ? null : widget.height,
                  // width: widget.vertical ? widget.width : null,
                  triggerMode: widget.triggerMode,
                  buttonStyle: widget.buttonStyle,
                ),
              ),
            )
            .toList();
    if (widget.vertical) {
      return Column(children: btns);
    }
    return Row(children: btns);
  }
}
