/**
 * This page displays the map from Google
 **/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  @override
  MapsPageState createState() => MapsPageState();
}

class MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;
  final LatLng _initial = const LatLng(47.471780, -0.551767);
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    final QuerySnapshot partners = await Firestore.instance
        .collection("companies")
        .getDocuments();
    setState(() {
      _markers.clear();
      for (DocumentSnapshot partner in partners.documents) {
        final marker = Marker(
          markerId: MarkerId(partner.documentID),
          position: LatLng(partner.data['latitude'], partner.data['longitude']),
          infoWindow: InfoWindow(
            title: partner.data['name'],
            snippet: partner.data['address'],
          ),
        );
        _markers[partner.data['name']] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _initial,
            zoom: 15.0,
          ),
          markers: _markers.values.toSet(),
        );
  }
}