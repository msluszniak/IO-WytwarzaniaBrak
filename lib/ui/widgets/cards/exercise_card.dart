import 'package:flutter/material.dart';
import 'package:flutter_demo/models/equipment.dart';
import 'package:flutter_demo/models/exercise.dart';
import 'package:flutter_demo/storage/dbmanager.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise selectedExercise;


  final List tags = const [
    "Pull-up bar",
    "Bench",
    "Dumbells",
    "Jumping rope",
    "Squat rack"
  ];
  final String loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In cursus id erat laoreet lacinia. Fusce porta eget nisi nec pulvinar. Aliquam tristique quam a est sodales condimentum. Sed ornare pulvinar iaculis. Praesent iaculis urna rutrum, pretium velit et, suscipit purus. Donec eget lacus ut erat mollis feugiat. Sed eros tellus, iaculis ac ullamcorper ac, bibendum quis velit. Integer at interdum lectus. Quisque maximus, lorem eget tempor sollicitudin, tellus lectus vestibulum nisi, ut commodo dui est vitae lectus. Ut aliquet massa sapien, a posuere sapien molestie nec. Vestibulum ultricies vestibulum laoreet. Aenean feugiat leo non ultrices ultricies. Vivamus venenatis, mauris nec imperdiet feugiat, lacus turpis pellentesque nibh, sit amet fermentum nisi odio et tortor. Suspendisse potenti. Mauris finibus ligula quis erat volutpat, id ultrices dui dictum.Duis sit amet tellus at libero convallis pulvinar. Sed dapibus felis justo, et bibendum nunc tempor sit amet. Nulla tempus blandit dolor, ut vehicula leo viverra sed. Sed in arcu tellus. Fusce vehicula pulvinar ante vitae vehicula. Nulla commodo quam quis mollis rhoncus. Integer imperdiet risus lacus, ut facilisis ex hendrerit ut. Praesent cursus et mauris non vulputate.Duis et nisl neque. Praesent ornare fringilla pharetra. Vivamus volutpat, diam id laoreet semper, lectus orci feugiat neque, vel mattis purus nunc et justo. Donec augue nibh, lacinia condimentum mollis quis, faucibus ut mi. Ut ac felis nec sapien ullamcorper imperdiet. Nulla vitae nulla varius metus pulvinar consequat quis et ligula. Fusce vitae orci vitae tellus elementum sollicitudin. Integer fermentum neque non massa dictum, cursus condimentum erat varius. Donec id viverra quam, rhoncus sollicitudin magna. Quisque fringilla sem sit amet nibh luctus fringilla. Integer vitae lacinia sapien. Sed volutpat egestas ipsum sed mattis.Pellentesque id fermentum enim. Suspendisse a dignissim libero, eu vehicula est. Vivamus accumsan nisi at sem mattis, eget mattis tortor vulputate. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis hendrerit, est a lobortis interdum, odio leo mollis mauris, quis ultricies lorem lectus id sem. Nullam ultrices erat vel lacus consectetur, at vestibulum mauris sollicitudin. Praesent in ex ipsum. Vestibulum id nisl eget enim eleifend egestas. Morbi nec tincidunt ex. In quis faucibus arcu. Mauris elementum tellus orci, at vulputate nunc mollis a. Morbi orci mauris, vulputate ut libero sed, vulputate imperdiet augue. Maecenas accumsan faucibus iaculis. Donec ut pellentesque est, eget ultrices mauris.Curabitur aliquet, justo sit amet luctus ornare, odio erat tempor lorem, vitae finibus nisl mauris in metus. Praesent non porta tellus. Curabitur rhoncus elit id tellus condimentum molestie. Vivamus sapien felis, laoreet et leo nec, fringilla fermentum est. Ut magna ipsum, fringilla vel lacus eu, ultrices sagittis felis. Morbi eleifend tempor molestie. In tristique neque sit amet lacus sagittis, in pellentesque urna cursus";

  const ExerciseCard({Key? key, required this.selectedExercise})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    final dbManager = context.watch<DBManager>();
    Future<List<Equipment>> equipment = dbManager.getJoined<Exercise, Equipment>(selectedExercise.id!);

    return new Scaffold(
      body: Center(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            horizontalTitleGap: 16.0,
            leading: Icon(Icons.fitness_center),
            title: Text(selectedExercise.name),
            subtitle: Row(
              children: [
                Text(selectedExercise.description!),
                FutureBuilder<List<Equipment>>(
                    future: equipment,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        final List<Equipment> equipmentList = snapshot.data!;
                        return Text(" " + equipmentList.first.name);
                      }
                    })
              ],
            ),
          ),
          Divider(
              height: 20,
              thickness: 1,
              indent: 5,
              endIndent: 5,
              color: Colors.grey),
          // Tags(
          //   itemCount: tags.length,
          //   itemBuilder: (int index) {
          //     final item = tags[index];
          //     return ItemTags(index: index, title: item);
          //   },
          // ),
          // Divider(
          //     height: 20,
          //     thickness: 1,
          //     indent: 5,
          //     endIndent: 5,
          //     color: Colors.grey),
          // Expanded(
          //   child: ListView(
          //     padding: const EdgeInsets.all(8),
          //     children: selectedGym.description == null ? [] : [
          //       Text(selectedGym.description!),
          //     ],
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: <Widget>[
          //     ElevatedButton(
          //       child: const Text('RATE'),
          //       onPressed: () {
          //         /* ... */
          //       },
          //     ),
          //     const SizedBox(width: 8),
          //     ElevatedButton(
          //       child: const Text('CHECK DISTANCE'),
          //       onPressed: () {
          //         selectedGym.getDistance().then((distance) => print(
          //             '[DEBUG] Distance to selected gym: ' +
          //                 distance.toString() +
          //                 "meters"));
          //       },
          //     ),
          //     const SizedBox(width: 8),
          //   ],
          // ),
        ],
      ),
      ),
    );
  }
}
