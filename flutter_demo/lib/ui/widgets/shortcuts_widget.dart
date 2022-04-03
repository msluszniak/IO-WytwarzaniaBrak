import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/widgets/shortcut_widget.dart';

class ShortcutsWidget extends StatelessWidget {
  const ShortcutsWidget({
    Key? key,
    required this.types
  }) : super(key: key);

  final List<ShortcutType> types;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: _buildShortcuts(),
  );

  List<Widget> _buildShortcuts() {
    List<Widget> widgets = [Spacer()];

    types.forEach((type) {
      widgets
        ..add(
          ShortcutWidget(
            shortcutType: type,
          ),
        )
        ..add(Spacer());
    });

    return widgets;
  }
}