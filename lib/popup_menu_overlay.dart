
import 'package:flutter/material.dart';

class PopupMenuOverlay extends StatelessWidget {
  final Widget child;
  final List<Widget> menuItems;
  final Offset position;
  final double width;
  final bool isSmallScreen;

  const PopupMenuOverlay({
    super.key,
    required this.child,
    required this.menuItems,
    required this.position,
    this.width = 200,
    this.isSmallScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSmallScreen) {
      return _buildDialog(context);
    }
    return _buildOverlay();
  }

  // 构建对话框模式的菜单
  Widget _buildDialog(BuildContext context) {
    return Dialog(
      child: Container(
        width: width,
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 返回按钮
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            const Divider(),
            // 菜单项列表
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: menuItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 构建悬浮层模式的菜单
  Widget _buildOverlay() {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: width,
          constraints: const BoxConstraints(maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: menuItems,
          ),
        ),
      ),
    );
  }
}
