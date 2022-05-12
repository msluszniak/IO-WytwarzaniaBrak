import 'package:flutter/material.dart';
import 'package:flutter_demo/models/gym.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../storage/dbmanager.dart';

class NewGymCard extends StatefulWidget {
  const NewGymCard(
      {Key? key,
      required this.mapController,
      required this.cancelCallback,
      required this.submitCallback})
      : super(key: key);

  final VoidCallback cancelCallback;
  final VoidCallback submitCallback;
  final MapController mapController;

  @override
  _NewGymState createState() => _NewGymState();
}

class _NewGymState extends State<NewGymCard> {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  static const List<String> tags = [
    "pull-up bar",
    "bench",
    "dumbells",
    "jumping rope",
    "squat rack",
    "treadmill",
    "leg press"
  ];
  List _items = [];
  double _fontSize = 14;

  @override
  void initState() {
    super.initState();
    _items = [];
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(
    //         top: Radius.circular(20),
    //         bottom: Radius.circular(20)
    //     )
    // ),
    final dbManager = context.watch<DBManager>();

    final latLng = LatLng(widget.mapController.center.latitude,
        widget.mapController.center.longitude);
    Future<String> address = Gym.getAddressFromLatLng(latLng);

    String? addressStr;

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Gym name',
              ),
            ),
            Divider(
                height: 20,
                thickness: 1,
                indent: 5,
                endIndent: 5,
                color: Colors.grey),
            Tags(
              key: _tagStateKey,
              //symmetry: true,
              //horizontalScroll: true,
              textDirection: TextDirection.rtl,
              //direction: Axis.vertical,
              textField: TagsTextField(
                autofocus: true,
                // inputDecoration: InputDecoration(
                //   border: InputBorder(),
                //   labelText: 'Tags',
                // ),
                textStyle: TextStyle(fontSize: _fontSize),
                constraintSuggestion: true,
                suggestions: _NewGymState.tags,
                //width: double.infinity, padding: EdgeInsets.symmetric(horizontal: 10),
                onSubmitted: (String str) {
                  // Add item to the data source.
                  setState(() {
                    // required
                    _items.add(str);
                  });
                },
              ),
              itemCount: _items.length,
              // required
              itemBuilder: (int index) {
                final item = _items[index];

                return ItemTags(
                  // Each ItemTags must contain a Key. Keys allow Flutter to
                  // uniquely identify widgets.
                  key: Key(index.toString()),
                  index: index,
                  pressEnabled: false,
                  // required
                  title: item,
                  textStyle: TextStyle(
                    fontSize: _fontSize,
                  ),
                  combine: ItemTagsCombine.withTextBefore,
                  removeButton: ItemTagsRemoveButton(
                    onRemoved: () {
                      // Remove the item from the data source.
                      setState(() {
                        // required
                        _items.removeAt(index);
                      });
                      //required
                      return true;
                    },
                  ),
                  // OR null,
                  onPressed: (item) => print(item),
                  onLongPressed: (item) => print(item),
                );
              },
            ),
            // Expanded(
            //   child: ListView(
            //     padding: const EdgeInsets.all(8),
            //     children: <Widget>[
            //       Text(""),
            //     ],
            //   ),
            // ),
            Divider(
                height: 20,
                thickness: 1,
                indent: 5,
                endIndent: 5,
                color: Colors.grey),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              maxLines: null,
            ),
            Divider(
                height: 20,
                thickness: 1,
                indent: 5,
                endIndent: 5,
                color: Colors.grey),
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.location_on),
                title: FutureBuilder<String>(
                    future: address,
                    builder: (builder, snapshot) {
                      if (!snapshot.hasData) {
                        return Row(
                          children: [
                            Center(
                              heightFactor: 1,
                              widthFactor: 1,
                              child: const SizedBox.square(
                                  child: CircularProgressIndicator()),
                            ),
                          ],
                        );
                      } else {
                        addressStr = snapshot.data!;
                      }
                      return Text(addressStr!);
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      widget.cancelCallback();
                    }),
                const SizedBox(width: 8),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    _showLoaderDialog(context);

                    if (addressStr == null) {
                      addressStr = await address;
                    }

                    final newGym = Gym(
                        lat: widget.mapController.center.latitude,
                        lng: widget.mapController.center.longitude,
                        name: nameController.text,
                        description: descController.text,
                        address: addressStr);

                    int result = await dbManager.addToDatabase(newGym);

                    Navigator.pop(context);

                    Fluttertoast.showToast(
                      msg: result == 200
                          ? "Added item succesfully"
                          : "Couldn't add item to database; Error code: $result",
                    );
                    widget.submitCallback();
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

// Allows you to get a list of all the ItemTags - for later
//   _getAllItem() {
//     List<Item>? lst = _tagStateKey.currentState?.getAllItem;
//     if (lst != null)
//       lst.where((a) => a.active == true).forEach((a) => print(a.title));
//   }

  _showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
