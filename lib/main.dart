import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'map_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 900, accuracy: loc.LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('live location tracker'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              _getLocation();
            },
            child: const Text('add my location'),
          ),
          TextButton(
            onPressed: () {
              _listLocation();
            },
            child: const Text('Enable Live location'),
          ),
          TextButton(
            onPressed: () {
              _stopLocation();
            },
            child: const Text('Disable Live location'),
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('location')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              snapshot.data!.docs[index]['name'].toString()),
                          subtitle: Row(
                            children: [
                              Text(snapshot.data!.docs[index]['longitude']
                                  .toString()),
                              SizedBox(width: 20.0),
                              Text(snapshot.data!.docs[index]['latitude']
                                  .toString()),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              //print('value_test${snapshot.data!.docs[index].id}');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MapScreen(
                                        snapshot.data!.docs[index].id,
                                      ),
                              ));
                            },
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('Docsid').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'Jehan'
      },
          // SetOptions(merge: true),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print('error_in_call_live');
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      print('print_properly');
      await FirebaseFirestore.instance.collection('location').add({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'Jehan'
      },
        // SetOptions(merge: true),
      );
    });
  }

  _stopLocation() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
