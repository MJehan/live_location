// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MyHomePage(),
//     );
//   }
// }

//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   bool mapToggle = false;
//   bool sitiosToggle = false;
//   bool resetToggle = false;
//
//   var currentLocation;
//
//   var sitios = [];
//
//   var sitioActual;
//   var currentBearing;
//
//    late GoogleMapController mapController;
//
//   void initState() {
//     super.initState();
//     setState(() {
//       mapToggle = true;
//       populateClients();
//     });
//   }
//
//   populateClients() {
//     sitios = [];
//     FirebaseFirestore.instance.collection('location').get().then((docs) {
//       if (docs.docs.isNotEmpty) {
//         setState(() {
//           sitiosToggle = true;
//         });
//         for (int i = 0; i < docs.docs.length; ++i) {
//           sitios.add(docs.docs[i].data);
//           initMarker(docs.docs[i].data);
//         }
//       }
//     });
//   }
//
//   initMarker(sitio) {
//     mapController.removeMarker(Marker(markerId: markerId)).then((val) {
//       mapController.addMarker(MarkerOptions(
//           position:
//           LatLng(sitio['location'].latitude, sitio['location'].longitude),
//           draggable: false,
//           infoWindowText: InfoWindowText(sitio['nombreSitio'], 'Cool')));
//     });
//   }
//
//   Widget siteCard(sitio) {
//     return Padding(
//         padding: EdgeInsets.only(left: 2.0, top: 10.0),
//         child: InkWell(
//             onTap: () {
//               setState(() {
//                 sitioActual = sitio;
//                 currentBearing = 90.0;
//               });
//               zoomInMarker(sitio);
//             },
//             child: Material(
//               elevation: 4.0,
//               borderRadius: BorderRadius.circular(5.0),
//               child: Container(
//                   height: 100.0,
//                   width: 125.0,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.0),
//                       color: Colors.white),
//                   child: Center(child: Text(sitio['nombreSitio']))),
//             )));
//   }
//
//   zoomInMarker(sitio) {
//     mapController
//         .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//         target: LatLng(
//             sitio['location'].latitude, sitio['location'].longitude),
//         zoom: 17.0,
//         bearing: 90.0,
//         tilt: 45.0)))
//         .then((val) {
//       setState(() {
//         resetToggle = true;
//       });
//     });
//   }
//
//   markerInicial() {
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: LatLng(51.0533076, 5.9260656), zoom: 5.0))).then((val) {//Alemania, Berlin
//       setState(() {
//         resetToggle = false;
//       });
//     });
//   }
//
//   girarDerecha() {
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(
//             target: LatLng(sitioActual['location'].latitude,
//                 sitioActual['location'].longitude
//             ),
//             bearing: currentBearing == 360.0 ? currentBearing : currentBearing + 90.0,
//             zoom: 17.0,
//             tilt: 45.0
//         )
//     )
//     ).then((val) {
//       setState(() {
//         if(currentBearing == 360.0) {}
//         else {
//           currentBearing = currentBearing + 90.0;
//         }
//       });
//     });
//   }
//
//   giroIzquierda() {
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(
//             target: LatLng(sitioActual['location'].latitude,
//                 sitioActual['location'].longitude
//             ),
//             bearing: currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
//             zoom: 17.0,
//             tilt: 45.0
//         )
//     )
//     ).then((val) {
//       setState(() {
//         if(currentBearing == 0.0) {}
//         else {
//           currentBearing = currentBearing - 90.0;
//         }
//       });
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Flutter+Markers+FireCloud'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Stack(
//               children: <Widget>[
//                 Container(
//                     height: MediaQuery.of(context).size.height - 80.0,
//                     width: double.infinity,
//                     child: mapToggle
//                         ? GoogleMap(
//                       initialCameraPosition: const CameraPosition(
//                           target: LatLng(48.8583998, 2.2932227),//Paris
//                           zoom: 15
//                       ),
//                       onMapCreated: onMapCreated,
//                       myLocationEnabled: true,
//                       mapType: MapType.hybrid,
//                       compassEnabled: true,
//                       //CameraPosition: true,
//                     )
//                         : const Center(
//                         child: Text(
//                           'Revisa datos, gps, wifi..',
//                           style: TextStyle(fontSize: 20.0),
//                         ))),
//                 //cajas markers segun numero de marcadores
//                 Positioned(
//                     top: MediaQuery.of(context).size.height - 150.0,
//                     left: 10.0,
//                     child: Container(
//                         height: 50.0,
//                         width: MediaQuery.of(context).size.width,
//                         child: sitiosToggle
//                             ? ListView(
//                           scrollDirection: Axis.horizontal,
//                           padding: const EdgeInsets.all(8.0),
//                           children: sitios.map((element) {
//                             return siteCard(element);
//                           }).toList(),
//                         )
//                             : Container(height: 1.0, width: 1.0))),
//                 //Fin container segun numero de marcadores
//                 //creamos tres botones giro izquierda derecha i resetar camara
//                 resetToggle
//                     ? Positioned(
//                     top: MediaQuery.of(context).size.height -
//                         (MediaQuery.of(context).size.height -
//                             50.0),
//                     right: 15.0,
//                     child: FloatingActionButton(
//                       onPressed: markerInicial,
//                       mini: true,
//                       backgroundColor: Colors.red,
//                       child: const Icon(Icons.refresh),
//                     ))
//                     : Container(),
//                 resetToggle
//                     ? Positioned(
//                     top: MediaQuery.of(context).size.height -
//                         (MediaQuery.of(context).size.height -
//                             50.0),
//                     right: 60.0,
//                     child: FloatingActionButton(
//                         onPressed: girarDerecha,
//                         mini: true,
//                         backgroundColor: Colors.green,
//                         child: const Icon(Icons.rotate_left
//                         ))
//                 )
//                     : Container(),
//                 resetToggle
//                     ? Positioned(
//                     top: MediaQuery.of(context).size.height -
//                         (MediaQuery.of(context).size.height -
//                             50.0),
//                     right: 110.0,
//                     child: FloatingActionButton(
//                         onPressed: giroIzquierda,
//                         mini: true,
//                         backgroundColor: Colors.blue,
//                         child: const Icon(Icons.rotate_right)
//                     ))
//                     : Container()
//               ],
//             )
//           ],
//         ));
//   }
//
//   void onMapCreated(controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }
// }





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
                                      //MapSample() //List Marker
                                        MapScreen(       //Single marker
                                          snapshot.data!.docs[index].id,
                                        ),
                              ),
                              );
                            },
                          ),
                        );
                      },
                  );
                },
            ),
          ),
        ],
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('DocsId').set({
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
