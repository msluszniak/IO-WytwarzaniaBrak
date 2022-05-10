import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysql1/mysql1.dart';

import '../models/gym.dart';

class Mysql {
  static String host = 'mysql.agh.edu.pl',
      user = 'mkardys1',
      password = 'uTRWajr6qjaKZn3y',
      db = 'mkardys1';

  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);

    return await MySqlConnection.connect(settings);
  }
}

Future<List<UserModel>> getmySQLData() async {
  var db = Mysql();

  String sql = 'select * from mkardys1.exercises';

  final List<UserModel> mylist = [];
  await db.getConnection().then((conn) async {
    await conn.query(sql).then((results) {
      for (var res in results) {
        final UserModel myuser = UserModel(
            id: res['ID'].toString(),
            name: res['name'].toString(),
            equipment: res['equipment'].toString(),
            bodyPart: res['bodyPart'].toString());

        mylist.add(myuser);
      }
    }).onError((error, stackTrace) {
      print(error);

      return null;
    });

    conn.close();
  });

  return mylist;
}

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
  });

  String equipment;

  String id;

  String name;

  String bodyPart;
}

FutureBuilder<List<UserModel>> showFutureDBData() {
  return FutureBuilder<List<UserModel>>(
    future: getmySQLData(),
    builder: (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      }

      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          final user = snapshot.data![index];

          return ListTile(
            leading: Text(user.id),

            title: Text(user.name),

            subtitle: Text("(" + user.bodyPart + ")"),

            // this part might be helpful soon, because it implements button with working favourite section.
            // trailing: IconButton(
            //   key: Key('icon_${user.ID}'),
            //   icon: favoritesList.items.contains(user.ID)
            //       ? const Icon(Icons.favorite)
            //       : const Icon(Icons.favorite_border),
            //   onPressed: () {
            //     !favoritesList.items.contains(user.ID)
            //         ? favoritesList.add(user.ID)
            //         : favoritesList.remove(user.ID);
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(favoritesList.items.contains(user.ID)
            //             ? 'Added to favorites.'
            //             : 'Removed from favorites.'),
            //         duration: const Duration(seconds: 1),
            //       ),
            //     );
            //   },
            // ),
          );
        },
      );
    },
  );
}

Future<List<Gym>> getGymData() async {
  var db = Mysql();

  String sql = 'select * from mkardys1.gym';

  final List<Gym> gymlist = [];
  await db.getConnection().then((conn) async {
    await conn.query(sql).then((results) {
      for (var res in results) {
        final Gym gym = Gym(
            lat: res['latitude'],
            lng: res['longitude'],
            name: res['name'].toString(),
            description: res['description'].toString(),
            address: res['address'].toString());
        gymlist.add(gym);
      }
    }).onError((error, stackTrace) {
      print(error);

      return null;
    });

    conn.close();
  });

  return gymlist;
}

Future<int?> addGymData(Gym gym) async {
  var db = Mysql();

  String name = gym.getName();
  String desc = gym.getDescription();
  String? addr = gym.getAddress();
  LatLng latlng = gym.getLatLng();
  String sql =
      'insert into gym (name, longitude, latitude, description, address) values (\'$name\', \'${latlng.longitude}\', \'${latlng.latitude}\', \'$desc\', \'$addr\')';

  int? index = -1;
  await db.getConnection().then((conn) async {
    await conn.query(sql).then((results) {
      index = results.insertId;
    }).onError((error, stackTrace) {
      print(error);

      return null;
    });

    conn.close();
  });

  return index;
}

FutureBuilder<List<Gym>> showGymMarkers(void Function(Gym) onMarkerPressed) {
  return FutureBuilder<List<Gym>>(
      future: getGymData(),
      builder: (BuildContext context, AsyncSnapshot<List<Gym>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return MarkerLayerWidget(
          options: MarkerLayerOptions(
            markers: List.generate(
              snapshot.data!.length,
              (index) => Marker(
                width: 80.0,
                height: 80.0,
                point: snapshot.data![index].getLatLng(),
                builder: (ctx) => Container(
                  child: IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: () => onMarkerPressed(snapshot.data![index])),
                ),
              ),
            ),
          ),
        );
      });
}
