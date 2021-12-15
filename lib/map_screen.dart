import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';


//-------------Single Marker------------------
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



//------------------------List Marker------------------------
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
//   crearmarcadores(){
//     _database.collection('location')
//         .get().then((value) {
//       if(value.docs.isNotEmpty){
//         for(int i= 0; i < value.docs.length; i++) {
//           initMarker(value.docs[i].data, value.docs[i].id);
//         }
//       }
//     });
//   }
//   void initMarker(index, lugaresid) {
//     var markerIdVal = lugaresid;
//     final MarkerId markerId = MarkerId(markerIdVal);
//
//     // creating a new MARKER
//     final Marker marker = Marker(
//       markerId: markerId,
//       position: LatLng(index['Latitud'], index['Longitud']),
//       infoWindow: InfoWindow(title: index['name']),
//     );
//
//     setState(() {
//       // adding a new marker to map
//       markers[markerId] = marker;
//     });
//   }
//
//   static const CameraPosition _kinitialPosition = CameraPosition(
//     target: LatLng(23.7011183, 90.3931575),
//     zoom: 14.4746,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: _kinitialPosition,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//         myLocationEnabled: true,
//         markers: Set<Marker>.of(markers.values),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _currentLocation,
//         label: const Text('Ir a mi Ubicacion!'),
//         icon: const Icon(Icons.location_on),
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
//
//     controller.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(
//         bearing: 0,
//         target: LatLng(currentLocation!.latitude!.toDouble(), currentLocation!.longitude!.toDouble()),
//         zoom: 17.0,
//       ),
//     ),
//     );
//   }
// }
//
