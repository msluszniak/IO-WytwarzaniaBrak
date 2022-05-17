import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/pages/exercises_page.dart';
import 'package:flutter_demo/ui/pages/workouts_page.dart';
import 'package:flutter_demo/ui/pages/map_page.dart';

abstract class _Constants {
  static const double iconSize = 60;
  static const int flex = 3;
}

enum ShortcutType { map, workouts, exercises }

class ShortcutWidget extends StatelessWidget {
  const ShortcutWidget({Key? key, required this.shortcutType}) : super(key: key);

  final ShortcutType shortcutType;

  @override
  Widget build(BuildContext context) => Expanded(
        flex: _Constants.flex,
        child: _buildShortcutContainer(
            context, _shortcutImage(shortcutType), _shortcutName(shortcutType), _shortcutDestination(shortcutType)),
      );

  Widget _buildShortcutContainer(BuildContext context, Image activityIcon, String title, String destination) =>
      TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 3,
        ),
        onPressed: () {
          Navigator.pushNamed(context, destination);
        },
        child: Container(
          child: Center(
            child: _buildShortcutColumn(context, activityIcon, title),
          ),
        ),
      );

  Widget _buildShortcutColumn(
    BuildContext context,
    Image shortcutIcon,
    String title,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: _Constants.iconSize,
            height: _Constants.iconSize,
            child: shortcutIcon,
          ),
          SizedBox(height: 10),
          Opacity(
            opacity: 0.75,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      );

  Image _shortcutImage(ShortcutType shortcutType) {
    switch (shortcutType) {
      case ShortcutType.map:
        return Image.asset('assets/images/map.png');
      case ShortcutType.workouts:
        return Image.asset('assets/images/dumbbell.png');
      case ShortcutType.exercises:
        return Image.asset('assets/images/exercise.png');
    }
  }

  String _shortcutName(ShortcutType shortcutType) {
    switch (shortcutType) {
      case ShortcutType.map:
        return 'Map';
      case ShortcutType.workouts:
        return 'Workouts';
      case ShortcutType.exercises:
        return 'Exercises';
    }
  }

  String _shortcutDestination(ShortcutType shortcutType) {
    switch (shortcutType) {
      case ShortcutType.map:
        return MapPage.routeName;
      case ShortcutType.workouts:
        return WorkoutsPage.routeName;
      case ShortcutType.exercises:
        return ExercisesPage.routeName;
    }
  }
}
