// Helper widget, to dispatch Notifications when a right-click is detected on some child
import 'package:context_menus/context_menus.dart';
import 'package:flutter/widgets.dart';

/// Wraps any widget in a GestureDetector and calls [ContextMenuOverlay].show
class CustomContextMenuRegion extends StatelessWidget {
  const CustomContextMenuRegion(
      {Key? key,
      required this.child,
      required this.contextMenu,
      this.isEnabled = true,
      this.enableLongPress = false})
      : super(key: key);
  final Widget child;
  final Widget contextMenu;
  final bool isEnabled;
  final bool enableLongPress;
  @override
  Widget build(BuildContext context) {
    void showMenu() {
      // calculate widget position on screen
      context.contextMenuOverlay.show(contextMenu);
    }

    if (isEnabled == false) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: showMenu,
      onLongPress: enableLongPress ? showMenu : null,
      child: child,
    );
  }
}
