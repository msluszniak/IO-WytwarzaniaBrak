import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/nav_bar.dart';
import 'package:flutter_demo/ui/widgets/shortcut_widget.dart';
import 'package:flutter_demo/ui/widgets/shortcuts_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Spacer(),
            _buildShortcutsWidget()
          ],
        ),
      ),
    );
  }
}

Widget _buildShortcutsWidget() => Padding(
  padding: EdgeInsets.only(bottom: 16),
  child: ShortcutsWidget(
    types: [
      ShortcutType.map,
      ShortcutType.gym,
      ShortcutType.exercises
    ],
  ),
);
