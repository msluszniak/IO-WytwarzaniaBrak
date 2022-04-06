import 'package:flutter/material.dart';
import 'package:flutter_demo/models/gym.dart';

class GymCard extends StatelessWidget {

  final Gym selectedGym;

  const GymCard({Key? key, required this.selectedGym})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.sports_gymnastics),
                title: Text(selectedGym.getName()),
                subtitle: Text(selectedGym.getDescription()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('RATE'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('CHECK DISTANCE'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
    );
  }

}