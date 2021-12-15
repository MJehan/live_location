import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  final String user_id;
  const MapScreen(this.user_id);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>  {
  final loc.Location Location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('location').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
          {
            if(_added)
            {
              map(snapshot);
            }
            if(!snapshot.hasData)
            {
              return const Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              mapType: MapType.normal,
              markers: {
                Marker(
                  position: LatLng(
                    snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.user_id)['latitude'],
                    snapshot.data!.docs.singleWhere(
                            (element) => element.id == widget.user_id)['longitude'],
                  ),
                  infoWindow: const InfoWindow(title: 'Hello I am Here..!!!'),
                  markerId: const MarkerId('id'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta,
                  ),
                ),
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['latitude'],
                      snapshot.data!.docs.singleWhere(
                              (element) => element.id == widget.user_id)['longitude']
                  ),zoom: 14.47
              ),
              onMapCreated: (GoogleMapController controller) async{
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              },
            );
          }
      ),
    );
  }

  Future<void> map(AsyncSnapshot<QuerySnapshot> snapshot) async{
    await _controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target:LatLng(
                snapshot.data!.docs.singleWhere(
                        (element) => element.id == widget.user_id)['latitude'],
                snapshot.data!.docs.singleWhere(
                        (element) => element.id == widget.user_id)['longitude']
            ),zoom: 14.47))
    );
  }
}



//
// class TestMapPolyline extends StatefulWidget {
//   @override
//   _TestMapPolylineState createState() => _TestMapPolylineState();
// }
//
// class _TestMapPolylineState extends State<TestMapPolyline> {
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polyline = {};
//
//   late GoogleMapController controller;
//
//   List<LatLng> latlngSegment1 = [];
//   List<LatLng> latlngSegment2 = [];
//   static LatLng _lat1 = LatLng(23.7011183, 90.3931575);
//   static LatLng _lat2 = LatLng(23.7511183, 90.3931575);
//   LatLng _lastMapPosition = _lat1;
//
//   @override
//   void initState() {
//     super.initState();
//     //line segment 1
//     latlngSegment1.add(_lat1);
//     latlngSegment1.add(_lat2);
//
//     //line segment 2
//     latlngSegment2.add(_lat1);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         //that needs a list<Polyline>
//         polylines: _polyline,
//         markers: _markers,
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: _lastMapPosition,
//           zoom: 11.0,
//         ),
//         mapType: MapType.normal,
//       ),
//     );
//   }
//
//   void _onMapCreated(GoogleMapController controllerParam) {
//     setState(() {
//       controller = controllerParam;
//       _markers.add(Marker(
//         // This marker id can be anything that uniquely identifies each marker.
//         markerId: MarkerId(_lastMapPosition.toString()),
//         //_lastMapPosition is any coordinate which should be your default
//         //position when map opens up
//         position: _lastMapPosition,
//         infoWindow: const InfoWindow(
//           title: 'Awesome Polyline tutorial',
//           snippet: 'This is a snippet',
//         ),
//       ));
//
//       _polyline.add(Polyline(
//         polylineId: const PolylineId('line1'),
//         visible: true,
//         //latlng is List<LatLng>
//         points: latlngSegment1,
//         width: 5,
//         color: Colors.blue,
//       ));
//
//       //different sections of polyline can have different colors
//       _polyline.add(Polyline(
//         polylineId: const PolylineId('line2'),
//         visible: true,
//         //latlng is List<LatLng>
//         points: latlngSegment2,
//         width: 2,
//         color: Colors.red,
//       ));
//     });
//   }
// }






//
// class MapSample extends StatefulWidget {
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final FirebaseFirestore _database = FirebaseFirestore.instance;
//   Completer<GoogleMapController> _controller = Completer();
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//
//   @override
//   void initState(){
//     crearmarcadores();
//     super.initState();
//   }
//
//   crearmarcadores(){
//     _database.collection('location')
//     // .where('tipo', isEqualTo: 'café')
//         .get().then((docs) {
//       if(docs.docs.isNotEmpty){
//         for(int i= 0; i < docs.docs.length; i++) {
//           initMarker(docs.docs[i].data, docs.docs[i].id);
//         }
//       }
//     });
//   }
//   void initMarker(lugar, lugaresid) {
//     var markerIdVal = lugaresid;
//     final MarkerId markerId = MarkerId(markerIdVal);
//
//     // creating a new MARKER
//     final Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(lugar['latitude'], lugar['longitude']),
//       icon: BitmapDescriptor.defaultMarkerWithHue(
//         BitmapDescriptor.hueMagenta,
//       ),
//       //infoWindow: InfoWindow(title: lugar['Lugar'], snippet: lugar['tipo']),
//     );
//
//     setState(() {
//       // adding a new marker to map
//       markers[markerId] = marker;
//     });
//   }
//
//
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         myLocationEnabled: true,
//         markers: Set<Marker>.of(markers.values),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _currentLocation,
//         label: const Text('Ir a mi Ubicacion!'),
//         icon: const Icon(Icons.location_on,color: Colors.red,),
//       ),
//     );
//   }
//
//
//
//   void _currentLocation() async {
//     final GoogleMapController controller = await _controller.future;
//     LocationData? currentLocation;
//     var location =  Location();
//     try {
//       currentLocation = await location.getLocation();
//     } on Exception {
//       currentLocation = null;
//     }
//     controller.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(
//         bearing: 0,
//         target: LatLng(currentLocation!.latitude!.toDouble(), currentLocation!.longitude!.toDouble()),
//         zoom: 17.0,
//       ),
//     ));
//   }
//
// }